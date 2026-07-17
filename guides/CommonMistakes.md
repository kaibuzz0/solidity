# Common Solidity Mistakes

**Learn from others' mistakes** — save time and avoid costly errors.

## 🔴 Critical Mistakes (Can Lose Money)

### 1. Reentrancy Attack

**VULNERABLE CODE:**
```solidity
function withdraw() public {
    uint256 amount = balances[msg.sender];
    require(amount > 0);
    
    // DANGER: External call before state update!
    (bool success, ) = msg.sender.call{value: amount}("");
    require(success);
    
    balances[msg.sender] = 0;  // Too late!
}
```

**ATTACKER CONTRACT:**
```solidity
contract Attacker {
    VulnerableBank public bank;
    
    function attack() external payable {
        bank.deposit{value: msg.value}();
        bank.withdraw();
    }
    
    receive() external payable {
        if (address(bank).balance >= msg.value) {
            bank.withdraw();  // Recursive call!
        }
    }
}
```

**SECURE CODE:**
```solidity
function withdraw() public {
    uint256 amount = balances[msg.sender];
    require(amount > 0, "No funds");
    
    // Update state FIRST
    balances[msg.sender] = 0;
    
    // Then transfer
    (bool success, ) = msg.sender.call{value: amount}("");
    require(success, "Transfer failed");
}
```

✅ **Rule:** Checks-Effects-Interactions pattern (state changes before external calls)

---

### 2. Integer Overflow/Underflow (Pre-0.8.x)

**VULNERABLE CODE:**
```solidity
// In Solidity 0.7.x and earlier:
function subtract(uint256 a, uint256 b) public pure returns (uint256) {
    return a - b;  // If b > a, wraps around to huge number!
}

// subtract(5, 10) returns 2^256 - 5 (HUGE number)
```

**SECURE CODE:**
```solidity
// In Solidity 0.8.x: Automatically checked!
function subtract(uint256 a, uint256 b) public pure returns (uint256) {
    return a - b;  // Reverts if b > a
}

// Or manually check:
function subtract(uint256 a, uint256 b) public pure returns (uint256) {
    require(b <= a, "Underflow");
    return a - b;
}

// Or use unchecked for gas savings (when safe):
function subtract(uint256 a, uint256 b) public pure returns (uint256) {
    unchecked {
        return a - b;  // No check, use carefully
    }
}
```

✅ **Rule:** Use Solidity 0.8.x+ for automatic overflow protection

---

### 3. Access Control Failures

**VULNERABLE CODE:**
```solidity
contract Vault {
    address public owner;
    
    function withdraw() public {
        // Missing check! Anyone can call this
        payable(msg.sender).transfer(address(this).balance);
    }
}
```

**SECURE CODE:**
```solidity
contract Vault {
    address public owner;
    
    constructor() {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }
    
    function withdraw() public onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
    
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Zero address");
        owner = newOwner;
    }
}
```

✅ **Rule:** Always check `msg.sender` for privileged functions

---

### 4. Unchecked External Call Return Values

**VULNERABLE CODE:**
```solidity
function transferToken(address token, address to, uint256 amount) public {
    // Return value ignored!
    IERC20(token).transfer(to, amount);
    
    // Continues even if transfer failed!
    balances[msg.sender] -= amount;
}
```

**SECURE CODE:**
```solidity
function transferToken(address token, address to, uint256 amount) public {
    bool success = IERC20(token).transfer(to, amount);
    require(success, "Transfer failed");
    
    balances[msg.sender] -= amount;
}

// Or use OpenZeppelin's SafeERC20:
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

using SafeERC20 for IERC20;

function transferToken(address token, address to, uint256 amount) public {
    IERC20(token).safeTransfer(to, amount);  // Reverts on failure
    balances[msg.sender] -= amount;
}
```

✅ **Rule:** Always check return values of external calls

---

## 🟡 Common Mistakes (Waste Gas / Bugs)

### 5. Forgetting `memory` / `storage`

**WRONG:**
```solidity
function getString() public pure returns (string) {
    // ERROR! Must specify data location
    return "hello";
}
```

**CORRECT:**
```solidity
function getString() public pure returns (string memory) {
    return "hello";
}

function processArray(uint256[] calldata arr) external {
    // calldata = cheapest for external functions
}

function modifyArray(uint256[] storage arr) internal {
    // storage = modifies original array
}
```

✅ **Rule:** Always specify `memory`, `storage`, or `calldata`

---

### 6. Modifying State in `view` Function

**WRONG:**
```solidity
uint256 public count;

function increment() public view {
    count++;  // ERROR: view function cannot modify state
}
```

**CORRECT:**
```solidity
function increment() public {
    count++;  // Remove 'view' keyword
}

function getCount() public view returns (uint256) {
    return count;  // view = reads only
}
```

✅ **Rule:** `view` = no state changes, `pure` = no state reads either

---

### 7. Misunderstanding `storage` vs `memory`

**BUGGY CODE:**
```solidity
contract ArrayBug {
    uint256[] public numbers = [1, 2, 3];
    
    function bug() public {
        uint256[] storage ptr = numbers;  // Reference, not copy!
        ptr[0] = 999;  // Modifies original array!
    }
    
    function alsoBug() public {
        uint256[] memory copy = numbers;  // Copies to memory
        copy[0] = 999;  // Only affects copy, not original
    }
}
```

✅ **Rule:** `storage` = pointer to original, `memory` = independent copy

---

### 8. Floating Point Issues

**PROBLEM:**
```solidity
function divide(uint256 a, uint256 b) public pure returns (uint256) {
    return a / b;  // Integer division! 5 / 2 = 2, not 2.5
}
```

**SOLUTIONS:**
```solidity
// Use larger numbers (wei instead of ether)
function calculatePercentage(uint256 amount, uint256 percent) 
    public pure returns (uint256) {
    // Multiply first to maintain precision
    return (amount * percent) / 100;
}

// For decimals, use fixed-point math
// Store 2.5 as 250 with implied 2 decimal places
// Or use libraries like ABDKMath
```

✅ **Rule:** Solidity has no floats; use integers with extra precision

---

### 9. Block Timestamp Manipulation

**RISKY:**
```solidity
function isEligible() public view returns (bool) {
    // Miners can manipulate timestamp slightly!
    return block.timestamp > 1234567890;
}
```

**BETTER:**
```solidity
function isEligible() public view returns (bool) {
    // Use block.number instead (harder to manipulate)
    return block.number > targetBlock;
}

// Or accept small window of manipulation
function isEligible() public view returns (bool) {
    return block.timestamp >= deadline;
    // Miner can only move forward by ~15 seconds
}
```

✅ **Rule:** `block.timestamp` can vary slightly; don't rely on exact values

---

## 🟢 Style Mistakes (Best Practices)

### 10. Not Using Events

**MISSING:**
```solidity
function transfer(address to, uint256 amount) public {
    balances[msg.sender] -= amount;
    balances[to] += amount;
    // No event emitted!
}
```

**BETTER:**
```solidity
event Transfer(address indexed from, address indexed to, uint256 amount);

function transfer(address to, uint256 amount) public {
    balances[msg.sender] -= amount;
    balances[to] += amount;
    emit Transfer(msg.sender, to, amount);  // Emits log
}
```

✅ **Rule:** Emit events for state changes (helps debugging + indexing)

---

### 11. Magic Numbers

**BAD:**
```solidity
if (percent > 50) {  // What is 50?
    // ...
}
```

**GOOD:**
```solidity
uint256 constant MAX_PERCENTAGE = 100;
uint256 constant MAJORITY_THRESHOLD = 50;

if (percent > MAJORITY_THRESHOLD) {
    // Clear what this means
}
```

✅ **Rule:** Use named constants instead of magic numbers

---

### 12. Missing Zero Address Checks

**BAD:**
```solidity
function setOwner(address newOwner) public {
    owner = newOwner;  // Could be address(0)!
}
```

**GOOD:**
```solidity
function setOwner(address newOwner) public {
    require(newOwner != address(0), "Zero address");
    owner = newOwner;
}
```

✅ **Rule:** Always validate addresses are not zero

---

## 📋 Security Checklist

Before deploying:

- [ ] Use Checks-Effects-Interactions pattern
- [ ] Check all external call return values
- [ ] Implement proper access control
- [ ] Emit events for state changes
- [ ] Validate inputs (addresses, amounts, lengths)
- [ ] Test with negative scenarios (reverts, edge cases)
- [ ] Consider reentrancy for any external calls
- [ ] Use established libraries (OpenZeppelin) when possible
- [ ] Get a security audit for production contracts

---

## 🎯 Fix Your Code

Use this pattern to check your contracts:

```solidity
// 1. Input validation
require(condition, "Error message");

// 2. Access control
onlyOwner / onlyAuthorized

// 3. State updates (before external calls!)
balances[msg.sender] -= amount;

// 4. External interactions (last!)
(bool success, ) = msg.sender.call{value: amount}("");
require(success, "Failed");

// 5. Emit event
emit ActionCompleted(msg.sender, amount);
```

---

**Want to learn secure coding?** See [Security Best Practices](../examples/07-SecurityBestPractices.sol)
