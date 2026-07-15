# Solidity Data Types Cheatsheet

## Value Types

| Type | Description | Example |
|------|-------------|---------|
| `bool` | Boolean | `bool isActive = true;` |
| `uint8` to `uint256` | Unsigned integer (8-bit steps) | `uint256 count = 100;` |
| `int8` to `int256` | Signed integer | `int256 temp = -10;` |
| `address` | 20-byte address | `address wallet;` |
| `address payable` | Address that can receive ETH | `address payable recipient;` |
| `bytes1` to `bytes32` | Fixed-size byte array | `bytes32 hash;` |
| `bytes` | Dynamic byte array | `bytes data;` |
| `string` | UTF-8 string | `string name;` |

## Reference Types

| Type | Storage Location | Example |
|------|-----------------|---------|
| Arrays | memory/storage/calldata | `uint256[] numbers;` |
| Structs | memory/storage | `struct Person { ... }` |
| Mappings | storage only | `mapping(address => uint) balances;` |

## Address Operations

```solidity
address addr = 0x123...;

// Balance
uint256 bal = addr.balance;           // Get balance in wei

// Transfer (2300 gas, reverts on failure)
payable(addr).transfer(1 ether);

// Send (2300 gas, returns bool)
bool success = payable(addr).send(1 ether);

// Call (forwards all gas)
(bool success, ) = addr.call{value: 1 ether}("");
```

## Type Aliases

| Alias | Actual Type |
|-------|-------------|
| `uint` | `uint256` |
| `uint` | `uint256` |
| `int` | `int256` |
| `byte` | `bytes1` |

## Integer Ranges

| Type | Min | Max |
|------|-----|-----|
| uint8 | 0 | 255 |
| uint16 | 0 | 65,535 |
| uint32 | 0 | 4,294,967,295 |
| uint256 | 0 | 2^256 - 1 |
| int8 | -128 | 127 |
| int256 | -2^255 | 2^255 - 1 |

## Literals

```solidity
// Ether units
1 wei == 1
1 gwei == 1e9
1 ether == 1e18

// Time units
1 seconds == 1
1 minutes == 60
1 hours == 3600
1 days == 86400
1 weeks == 604800

// Examples
uint256 amount = 2.5 ether;      // 2.5 * 10^18
uint256 delay = 1 days;        // 86400 seconds
```

## Data Locations

| Location | Lifetime | Use Case |
|----------|----------|----------|
| `storage` | Persistent (blockchain) | State variables |
| `memory` | Function execution | Temporary variables |
| `calldata` | Function execution | External function arguments (read-only) |

```solidity
function example(uint256[] calldata _data) external {
    // calldata is cheapest for external functions
    uint256[] memory copy = _data; // Explicit copy to memory
}
```

## Type Conversions

```solidity
// Explicit casting
uint256 a = uint256(int256(-1));  // Works (wraps around)
uint8 b = uint8(uint256(300));    // Works (truncates to 44)

// bytes <-> string
bytes memory b = bytes("hello");
string memory s = string(b);

// bytes <-> uint
uint256 num = uint256(bytes32("hello"));
bytes32 str = bytes32(uint256(123));
```

## Special Types

```solidity
// Enums
enum Status { Pending, Active, Completed }
Status current = Status.Pending;

// User-defined value type
type Decimal18 is uint256;

// Function type
function(uint256) external view returns (uint256) func;
```

## Common Pitfalls

⚠️ **In Solidity 0.8.x:**
- Overflow/underflow reverts automatically
- No need for SafeMath library
- Use `unchecked` for intentional overflow (gas savings)

⚠️ **String/bytes cannot be indexed:**
```solidity
// WRONG: string[0]
// CORRECT: bytes(string)[0]
```

⚠️ **Mappings don't have length:**
```solidity
mapping(address => uint) balances;
// balances.length ❌ Doesn't exist
```