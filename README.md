# Solidity Quick Reference

**Complete language reference organized for easy lookup**

## Table of Contents

| Section | Description |
|---------|-------------|
| [setup](./setup/) | Environment, tools, private chain setup |
| [basics](./basics/) | Types, variables, functions, control flow |
| [advanced](./advanced/) | Inheritance, libraries, assembly, patterns |
| [security](./security/) | Common vulnerabilities, best practices |
| [examples](./examples/) | Complete contract examples |
| [cheatsheets](./cheatsheets/) | Quick lookup sheets |
| [reference](./reference/) | Full API, opcodes, gas costs |

## Quick Start

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract HelloWorld {
    string public message;
    
    constructor(string memory _message) {
        message = _message;
    }
    
    function updateMessage(string memory _newMessage) public {
        message = _newMessage;
    }
}
```

## Documentation Links

- [Official Solidity Docs](https://docs.soliditylang.org/)
- [Solidity Cheatsheet](https://docs.soliditylang.org/en/latest/cheatsheet.html)
- [Ethereum Stack](https://ethereum.org/en/developers/docs/ethereum-stack/)
- [Breaking Changes (0.8.x)](https://docs.soliditylang.org/en/v0.8.7/080-breaking-changes.html)

## Learning Path

1. **Start here**: [First Contract](./examples/01-FirstContract.sol)
2. **Types**: [Data Types](./basics/DataTypes.md)
3. **Functions**: [Function Guide](./basics/Functions.md)
4. **Security**: [Common Vulnerabilities](./security/Vulnerabilities.md)
5. **Patterns**: [Design Patterns](./advanced/Patterns.md)

## Version Note

This reference covers Solidity **0.8.x** (current stable)

Key changes from 0.7.x:
- Arithmetic operations checked by default (no SafeMath needed)
- `unchecked` block for gas optimization
- New ABI coder v2 by default
- Custom errors instead of revert strings

---

**Created for organized learning and quick reference**