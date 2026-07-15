# Functions Cheatsheet

## Visibility

| Visibility | External | Internal | Inheritance |
|------------|----------|----------|-------------|
| `public` | ✅ | ✅ | ✅ |
| `external` | ✅ (only) | ❌ | ✅ |
| `internal` | ❌ | ✅ | ✅ |
| `private` | ❌ | ✅ | ❌ |

## State Mutability

| Mutability | Reads State | Modifies State | ETH |
|------------|-------------|----------------|-----|
| (default) | ✅ | ✅ | ❌ |
| `view` | ✅ | ❌ | ❌ |
| `pure` | ❌ | ❌ | ❌ |
| `payable` | ✅ | ✅ | ✅ |

## Function Signature

```solidity
function name(parameters) visibility mutability modifiers returns (types)
```

## Examples

```solidity
// Basic function
function getBalance() public view returns (uint256) {
    return address(this).balance;
}

// Multiple returns
function getValues() public pure returns (uint256 a, uint256 b) {
    return (1, 2);
}

// Named returns
function calculate() public pure returns (uint256 sum) {
    sum = 1 + 2; // No return statement needed
}

// Payable
function deposit() public payable {
    require(msg.value > 0, "Send ETH");
}

// External with calldata (cheaper)
function process(uint256[] calldata data) external pure {
    // data is read-only
}
```

## Function Selectors

```solidity
// Get function selector (first 4 bytes of keccak256 hash)
bytes4 selector = this.myFunction.selector;
// Or: bytes4(keccak256("myFunction(uint256,address)"))
```

## Calling Functions

```solidity
// Internal call
internalFunction();

// External call (this contract)
this.externalFunction();

// Call another contract
OtherContract(addr).functionName();

// Low-level call
(bool success, bytes memory data) = addr.call(
    abi.encodeWithSignature("functionName(uint256)", arg)
);

// Static call (view function)
(bool success, bytes memory data) = addr.staticcall(
    abi.encodeWithSignature("viewFunction()")
);

// Delegate call
(bool success, ) = addr.delegatecall(data);
```

## Modifiers

```solidity
modifier onlyOwner() {
    require(msg.sender == owner, "Not owner");
    _; // Function body inserted here
}

modifier nonReentrant() {
    require(!locked, "Reentrant");
    locked = true;
    _;
    locked = false;
}

modifier validAmount(uint256 _amount) {
    require(_amount > 0, "Zero amount");
    _;
}

// Usage
function critical() public onlyOwner nonReentrant validAmount(100) {
    // Function body
}
```

## Receive & Fallback

```solidity
// Called when ETH sent with no data
receive() external payable {
    // Handle plain ETH transfers
}

// Called when no function matches (or no receive)
fallback() external payable {
    // Handle unknown calls
}

// Both can be combined
fallback(bytes calldata _data) external payable returns (bytes memory) {
    // Handle unknown calls with data
    return _data;
}
```

## Custom Errors (0.8.4+)

```solidity
error InsufficientBalance(uint256 available, uint256 required);
error InvalidAddress(address addr);

function withdraw(uint256 _amount) public view {
    if (balance < _amount) {
        revert InsufficientBalance(balance, _amount);
    }
}
```

## Gas Optimization Tips

| Pattern | Gas Savings |
|---------|-------------|
| `external` vs `public` | ~200 gas |
| `calldata` vs `memory` | ~500 gas |
| Custom errors vs strings | ~100 gas |
| `unchecked` arithmetic | ~80 gas per operation |
| Short-circuit booleans | Variable |

```solidity
// Short-circuit (cheaper)
function check(uint256 x) public pure returns (bool) {
    // If x > 10, expensive() won't be called
    return x > 10 || expensive();
}

// Unchecked loop
for (uint256 i = 0; i < 100; ) {
    // ...
    unchecked { i++; }
}
```