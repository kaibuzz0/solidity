# Gas & Optimization Cheatsheet

## Storage Layout

```solidity
// Pack variables to save slots (32 bytes each)
uint128 balance;  // 16 bytes
uint128 allowance; // 16 bytes - shares slot
uint256 data;     // 32 bytes - new slot

// Order by size (largest first)
uint256 a;      // slot 0
address b;      // slot 1 (20 bytes)
uint64 c;       // slot 1 (8 bytes, packed)
uint32 d;       // slot 1 (4 bytes, packed)
```

## Variable Packing

| Combined Size | Slot Usage |
|---------------|------------|
| uint128 + uint128 | 1 slot ✅ |
| uint256 + uint256 | 2 slots |
| address + bool + uint8 | 1 slot ✅ |
| uint64 + uint64 + uint64 + uint64 | 1 slot ✅ |

## Optimization Techniques

### 1. Storage Variables

```solidity
// Bad: Multiple SSTOREs
function bad() public {
    a = 1;
    b = 2;
    c = 3;
}

// Good: Single struct SSTORE
struct Data { uint256 a; uint256 b; uint256 c; }
Data public data;

function good(uint256 _a, uint256 _b, uint256 _c) public {
    data = Data(_a, _b, _c);
}
```

### 2. Memory vs Storage

```solidity
// Bad: Multiple storage reads
function bad(uint256[] storage arr) internal {
    for (uint i = 0; i < arr.length; i++) {
        arr[i] = arr[i] + 1; // SLOAD each iteration
    }
}

// Good: Cache in memory
function good(uint256[] storage arr) internal {
    uint256[] memory temp = arr; // One SLOAD
    for (uint i = 0; i < temp.length; i++) {
        temp[i] = temp[i] + 1;
    }
    // Write back once
}
```

### 3. Loops

```solidity
// Bad: Uncached length
for (uint i = 0; i < array.length; i++) {
    // SLOAD on every iteration
}

// Good: Cached length
uint256 len = array.length;
for (uint256 i = 0; i < len; ) {
    // ...
    unchecked { i++; } // Cheaper increment
}
```

### 4. Unchecked Arithmetic

```solidity
// Gas: 226 (with checked arithmetic)
function add(uint256 a, uint256 b) public pure returns (uint256) {
    return a + b;
}

// Gas: 143 (unchecked)
function addUnchecked(uint256 a, uint256 b) public pure returns (uint256) {
    unchecked {
        return a + b;
    }
}
```

### 5. Custom Errors vs Strings

```solidity
// Gas: ~300 (string)
require(balance >= amount, "Insufficient balance");

// Gas: ~100 (custom error)
error InsufficientBalance(uint256 available, uint256 required);
if (balance < amount) {
    revert InsufficientBalance(balance, amount);
}
```

### 6. Calldata vs Memory

```solidity
// Gas: ~500 more (memory)
function withMemory(uint256[] memory arr) external {}

// Gas: cheaper (calldata)
function withCalldata(uint256[] calldata arr) external {}
```

## Gas Costs Reference

| Operation | Gas Cost |
|-----------|----------|
| SSTORE (new slot) | 20,000 |
| SSTORE (existing) | 5,000 |
| SLOAD (warm) | 100 |
| SLOAD (cold) | 2,100 |
| CALL | 2,600 |
| STATICCALL | 2,600 |
| DELEGATECALL | 2,600 |
| LOG0 (no topics) | 375 |
| LOG1 (1 topic) | 750 |
| Create | 32,000 |
| Selfdestruct | 5,000 |
| Keccak256 | 30 + 6 per word |

## Cheapest Operations

```solidity
// Very cheap (3-5 gas)
block.number
msg.sender
msg.value

// Cheap (comparison, bitwise)
a > b
a & b
a | b
a ^ b
~a

// Free (pure/view)
add pure functions
constant variables
```

## Assembly for Maximum Gas Savings

```solidity
function cheapSwap(address[] storage arr, uint i, uint j) internal {
    assembly {
        let slot_i := add(arr.slot, mul(i, 0x20))
        let slot_j := add(arr.slot, mul(j, 0x20))
        let val_i := sload(slot_i)
        let val_j := sload(slot_j)
        sstore(slot_i, val_j)
        sstore(slot_j, val_i)
    }
}
```

## Gas Estimation

```solidity
// Test with:
// 1. Remix IDE (execution cost)
// 2. Hardhat gas reporter
// 3. Foundry's gas snapshots

// Example pattern for estimation
uint256 startGas = gasleft();
functionToTest();
uint256 gasUsed = startGas - gasleft();
```