# Solidity Complete Reference

**The most beginner-friendly Solidity documentation** — organized for quick learning and easy reference.

## 🚀 Quick Start (30 seconds)

**Install and run your first contract:**

```bash
# 1. Install Node.js (if not installed)
# 2. Install Hardhat (development environment)
npm install --save-dev hardhat

# 3. Create a project
npx hardhat init

# 4. Write your first contract (see examples/01-FirstContract.sol)
# 5. Deploy and test!
```

## 📚 Learning Path (Follow in order)

| Step | Topic | File | What You'll Learn |
|------|-------|------|-------------------|
| 1 | **First Contract** | [examples/01-FirstContract.sol](examples/01-FirstContract.sol) | Variables, functions, events |
| 2 | **Data Types** | [cheatsheets/DataTypes.md](cheatsheets/DataTypes.md) | All Solidity types |
| 3 | **Functions** | [cheatsheets/Functions.md](cheatsheets/Functions.md) | Function types, visibility, modifiers |
| 4 | **Control Flow** | [examples/04-ControlStructures.sol](examples/04-ControlStructures.sol) | If/else, loops, error handling |
| 5 | **ERC20 Token** | [examples/05-ERC20Token.sol](examples/05-ERC20Token.sol) | Build a real token |
| 6 | **Security** | [examples/07-SecurityBestPractices.sol](examples/07-SecurityBestPractices.sol) | Write secure code |
| 7 | **Advanced** | [examples/08-InheritanceLibraries.sol](examples/08-InheritanceLibraries.sol) | Inheritance, libraries, patterns |

## 🎯 Quick Lookup (Experienced Developers)

Jump directly to what you need:

- **[Data Types](cheatsheets/DataTypes.md)** — Every type with examples
- **[Functions](cheatsheets/Functions.md)** — Visibility, modifiers, gas
- **[Gas Optimization](cheatsheets/GasOptimization.md)** — Save transaction costs
- **[Global Variables](cheatsheets/GlobalVariables.md)** — msg.sender, block.timestamp, etc.

## 📖 Complete Documentation

### For Beginners
- **[Setup Guide](setup/PrivateChain.md)** — Install everything you need
- **[First Contract](examples/01-FirstContract.sol)** — Line-by-line explanation
- **[Common Mistakes](guides/CommonMistakes.md)** — What NOT to do

### Core Concepts
- **[Data Types](cheatsheets/DataTypes.md)** — Value types, reference types, conversions
- **[Functions](cheatsheets/Functions.md)** — Pure, view, payable, internal, external
- **[Control Structures](examples/04-ControlStructures.sol)** — If/else, for, while, try/catch
- **[Error Handling](guides/ErrorHandling.md)** — Require, revert, assert, custom errors

### Advanced Topics
- **[Inheritance](examples/08-InheritanceLibraries.sol)** — Single, multiple, abstract contracts
- **[Libraries](examples/08-InheritanceLibraries.sol)** — Reusable code
- **[Design Patterns](examples/06-DesignPatterns.sol)** — Ownable, Pausable, Factory, Proxy
- **[Gas Optimization](cheatsheets/GasOptimization.md)** — Write cheaper code

### Security (CRITICAL)
- **[Security Best Practices](examples/07-SecurityBestPractices.sol)** — Secure coding patterns
- **[Common Vulnerabilities](guides/Vulnerabilities.md)** — Reentrancy, overflow, access control
- **[Security Checklist](guides/SecurityChecklist.md)** — Before deploying

### Reference
- **[Global Variables](cheatsheets/GlobalVariables.md)** — block, msg, tx, abi
- **[ERC20 Token](examples/05-ERC20Token.sol)** — Complete implementation
- **[Assembly](guides/Assembly.md)** — Low-level Yul
- **[Events](guides/Events.md)** — Logging and monitoring

## 💡 Code Examples

### Hello World Contract

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// Every contract starts with the 'contract' keyword
contract HelloWorld {
    // State variable - stored permanently on blockchain
    string public message;
    
    // Constructor runs once when contract is deployed
    constructor(string memory _message) {
        message = _message;
    }
    
    // Function to update the message
    // 'public' means anyone can call it
    // 'memory' means temporary storage (cheaper)
    function updateMessage(string memory _newMessage) public {
        message = _newMessage;
    }
    
    // 'view' means it only reads, doesn't modify
    // Returns are free (no gas cost)
    function getMessage() public view returns (string memory) {
        return message;
    }
}
```

### Simple Counter

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Counter {
    uint256 public count = 0;  // Starts at 0
    
    // Increment by 1
    function increment() public {
        count += 1;  // In 0.8.x, overflow is automatically checked
    }
    
    // Decrement with safety check
    function decrement() public {
        require(count > 0, "Cannot go below 0");  // Prevents underflow
        count -= 1;
    }
    
    // Get current count (free to call)
    function getCount() public view returns (uint256) {
        return count;
    }
}
```

## 🎓 Learning Tips

### 1. Read Code in Order
Start with [01-FirstContract.sol](examples/01-FirstContract.sol) and progress through the numbered examples.

### 2. Practice Every Concept
Each example file has comments explaining WHY, not just WHAT.

### 3. Use the Cheatsheets
Bookmark the cheatsheets for quick reference while coding.

### 4. Test Your Code
Use [Remix IDE](https://remix.ethereum.org/) for instant testing — no setup needed!

### 5. Understand Gas
Every operation costs gas (money). See [GasOptimization.md](cheatsheets/GasOptimization.md).

## 🔧 Development Tools

| Tool | Purpose | Link |
|------|---------|------|
| **Remix** | Online IDE (easiest) | [remix.ethereum.org](https://remix.ethereum.org/) |
| **Hardhat** | Professional dev environment | [hardhat.org](https://hardhat.org/) |
| **Foundry** | Fast testing framework | [getfoundry.sh](https://getfoundry.sh/) |
| **OpenZeppelin** | Secure contract library | [openzeppelin.com](https://www.openzeppelin.com/) |

## 📝 Version Notes

This reference covers **Solidity 0.8.x** (current stable):

✅ **Safe by default** — Arithmetic overflow/underflow automatically reverts  
✅ **No SafeMath needed** — Built-in overflow protection  
✅ **Custom errors** — Cheaper than revert strings  
✅ **Unchecked blocks** — For intentional overflow (gas savings)  

See [Breaking Changes](https://docs.soliditylang.org/en/v0.8.19/080-breaking-changes.html) for migration from older versions.

## 🐛 Troubleshooting

| Problem | Solution | See Also |
|---------|----------|----------|
| "Out of gas" | Optimize storage access | [GasOptimization.md](cheatsheets/GasOptimization.md) |
| "Stack too deep" | Use structs or local variables | [Functions.md](cheatsheets/Functions.md) |
| "Invalid opcode" | Check array bounds | [Error Handling](guides/ErrorHandling.md) |
| High deployment cost | Use smaller types, pack variables | [Gas Cheatsheet](cheatsheets/GasOptimization.md) |

## 🔗 External Resources

- [Official Solidity Documentation](https://docs.soliditylang.org/)
- [Solidity by Example](https://solidity-by-example.org/)
- [CryptoZombies](https://cryptozombies.io/) — Interactive tutorials
- [Ethernaut](https://ethernaut.openzeppelin.com/) — Security challenges
- [Ethereum Stack Exchange](https://ethereum.stackexchange.com/)

## 📂 Repository Structure

```
solidity/
├── README.md                    ← You are here
├── cheatsheets/                 ← Quick reference
│   ├── DataTypes.md
│   ├── Functions.md
│   ├── GasOptimization.md
│   └── GlobalVariables.md
├── examples/                    ← Learning examples
│   ├── 01-FirstContract.sol
│   ├── 02-DataTypes.sol
│   ├── 03-Functions.sol
│   ├── 04-ControlStructures.sol
│   ├── 05-ERC20Token.sol
│   ├── 06-DesignPatterns.sol
│   ├── 07-SecurityBestPractices.sol
│   └── 08-InheritanceLibraries.sol
├── guides/                      ← Detailed guides
│   ├── CommonMistakes.md
│   ├── ErrorHandling.md
│   ├── Events.md
│   ├── SecurityChecklist.md
│   ├── Vulnerabilities.md
│   └── Assembly.md
├── setup/                       ← Environment setup
│   ├── PrivateChain.md
│   └── Genesis.json
└── legacy/                      ← Older examples
```

## ⚡ Quick Command Reference

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;  // Version declaration

contract MyContract {
    // State variables (stored on blockchain)
    uint256 public myNumber;
    address public owner;
    
    // Events (for logging)
    event NumberChanged(uint256 oldValue, uint256 newValue);
    
    // Constructor (runs on deployment)
    constructor() {
        owner = msg.sender;  // Who deployed the contract
    }
    
    // Functions
    function setNumber(uint256 _num) public {
        require(_num > 0, "Must be positive");  // Validation
        emit NumberChanged(myNumber, _num);     // Log event
        myNumber = _num;
    }
    
    // View function (free to call)
    function getNumber() public view returns (uint256) {
        return myNumber;
    }
}
```

---

**Ready to start?** Open [examples/01-FirstContract.sol](examples/01-FirstContract.sol) and begin your Solidity journey!

**Questions?** Check the [troubleshooting section](#-troubleshooting) or the detailed guides in the `guides/` folder.
