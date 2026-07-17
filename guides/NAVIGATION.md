# 📖 How to Use This Reference

**Quickly find what you need** — organized by skill level and topic.

## 🎯 I Want To...

### Learn Solidity from Scratch

**Complete Beginner:**
1. Start here → [Getting Started](GettingStarted.md)
2. Follow → [Learning Roadmap](Roadmap.md)
3. Code along → [First Contract](../examples/01-FirstContract.sol)

**Already Know Some Solidity:**
- Jump to → [Data Types Cheatsheet](../cheatsheets/DataTypes.md)
- Study → [Functions Cheatsheet](../cheatsheets/Functions.md)
- Practice → [Examples](../examples/)

### Find Quick Reference

**Need to look up something fast?**
- [Data Types](../cheatsheets/DataTypes.md) — Every Solidity type
- [Functions](../cheatsheets/Functions.md) — Visibility, modifiers
- [Gas Optimization](../cheatsheets/GasOptimization.md) — Save money
- [Global Variables](../cheatsheets/GlobalVariables.md) — msg.sender, block.timestamp

### Build a Specific Project

**Token Development:**
- Start → [ERC20 Token](../examples/05-ERC20Token.sol)
- Study → [Inheritance](../examples/08-InheritanceLibraries.sol)
- Optimize → [Gas Cheatsheet](../cheatsheets/GasOptimization.md)

**DeFi Application:**
- Security → [Security Best Practices](../examples/07-SecurityBestPractices.sol)
- Patterns → [Design Patterns](../examples/06-DesignPatterns.sol)
- Check → [Common Mistakes](CommonMistakes.md)

### Fix a Bug

**Security Issue?**
1. Check → [Common Mistakes](CommonMistakes.md)
2. Review → [Security Best Practices](../examples/07-SecurityBestPractices.sol)
3. Audit → [Security Checklist](SecurityChecklist.md)

**Compilation Error?**
- See → [Common Mistakes](CommonMistakes.md)
- Check → [Data Types Cheatsheet](../cheatsheets/DataTypes.md)

### Optimize My Code

**Gas Costs Too High?**
1. Read → [Gas Optimization](../cheatsheets/GasOptimization.md)
2. Check → [Common Mistakes](CommonMistakes.md) (gas section)
3. Benchmark → [Global Variables](../cheatsheets/GlobalVariables.md)

## 📂 File Organization

```
solidity/
├── README.md                    ← Start here
├── 
├── 📚 Learning Paths/
│   ├── guides/
│   │   ├── GettingStarted.md    ← First time setup
│   │   ├── Roadmap.md           ← Complete learning path
│   │   └── CommonMistakes.md    ← Avoid these errors
│   │
│   └── examples/                ← Code examples
│       ├── 01-FirstContract.sol ← Start here
│       ├── 02-DataTypes.sol
│       ├── 03-Functions.sol
│       ├── 04-ControlStructures.sol
│       ├── 05-ERC20Token.sol
│       ├── 06-DesignPatterns.sol
│       ├── 07-SecurityBestPractices.sol
│       └── 08-InheritanceLibraries.sol
│
├── 📖 Quick Reference/
│   └── cheatsheets/
│       ├── DataTypes.md         ← All Solidity types
│       ├── Functions.md         ← Function reference
│       ├── GasOptimization.md   ← Save gas
│       └── GlobalVariables.md   ← Built-in variables
│
├── 🔧 Setup/
│   └── setup/
│       ├── PrivateChain.md      ← Run local blockchain
│       └── Genesis.json
│
└── 📦 Legacy/
    └── legacy/                  ← Older examples
```

## 🔍 Find by Topic

### Data Types
- [Data Types Cheatsheet](../cheatsheets/DataTypes.md)
- [Data Types Example](../examples/02-DataTypes.sol)

### Functions
- [Functions Cheatsheet](../cheatsheets/Functions.md)
- [Functions Example](../examples/03-Functions.sol)

### Security
- [Security Best Practices](../examples/07-SecurityBestPractices.sol)
- [Common Mistakes](CommonMistakes.md)
- [Security Checklist](SecurityChecklist.md)
- [Vulnerabilities](Vulnerabilities.md)

### Advanced
- [Inheritance & Libraries](../examples/08-InheritanceLibraries.sol)
- [Design Patterns](../examples/06-DesignPatterns.sol)
- [Assembly](Assembly.md)

### Gas Optimization
- [Gas Optimization Cheatsheet](../cheatsheets/GasOptimization.md)
- [Common Mistakes - Gas Section](CommonMistakes.md)

## 💡 Pro Tips

### Learning Efficiently
1. **Read → Code → Review**
   - Read the concept
   - Code it yourself
   - Compare with examples

2. **Spaced Repetition**
   - Review cheatsheets weekly
   - Re-read examples monthly
   - Build projects regularly

3. **Active Recall**
   - Try to write code from memory
   - Explain concepts out loud
   - Teach someone else

### Finding Answers Fast

**Use Search (Ctrl+F / Cmd+F):**
- Each cheatsheet is searchable
- Use specific keywords
- Check multiple files

**Bookmark Frequently Used Pages:**
- [Data Types Cheatsheet](../cheatsheets/DataTypes.md)
- [Functions Cheatsheet](../cheatsheets/Functions.md)
- [Gas Optimization](../cheatsheets/GasOptimization.md)

### Staying Updated

1. **Check for Updates:**
   - `git pull` regularly
   - Watch repository for changes
   - Read commit messages

2. **Contribute:**
   - Found an error? Report it
   - Have a better example? Submit PR
   - Missing topic? Request it

## 🎓 Recommended Order

### Complete Beginner
```
README.md
  ↓
GettingStarted.md
  ↓
01-FirstContract.sol
  ↓
02-DataTypes.sol
  ↓
03-Functions.sol
  ↓
DataTypes.md (reference)
  ↓
Functions.md (reference)
  ↓
Roadmap.md (follow full path)
```

### Experienced Developer
```
README.md
  ↓
05-ERC20Token.sol (if building tokens)
  ↓
06-DesignPatterns.sol
  ↓
07-SecurityBestPractices.sol
  ↓
08-InheritanceLibraries.sol
  ↓
Cheatsheets (bookmark these)
  ↓
CommonMistakes.md (security check)
```

### Security Focus
```
07-SecurityBestPractices.sol
  ↓
CommonMistakes.md
  ↓
SecurityChecklist.md
  ↓
Vulnerabilities.md
  ↓
Examples (read with security mindset)
```

## 🆘 Getting Help

**Can't find something?**
1. Use Ctrl+F in this file
2. Check the [main README](../README.md)
3. Look in the relevant cheatsheet
4. Search examples for keywords

**Still stuck?**
- See [Troubleshooting](GettingStarted.md#-troubleshooting)
- Check [Common Mistakes](CommonMistakes.md)
- Review [Getting Started](GettingStarted.md)

**Want to contribute?**
- See something missing? Add it!
- Found an error? Fix it!
- Have a better explanation? Share it!

---

**Remember:** This is a reference, not a novel. 
- Read the [Getting Started](GettingStarted.md) guide once
- Use [cheatsheets](../cheatsheets/) for quick lookup
- Code along with [examples](../examples/)
- Follow the [Roadmap](Roadmap.md) for structure

**Start coding → Reference → Code more → Master**
