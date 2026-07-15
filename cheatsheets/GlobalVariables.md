# Global Variables Cheatsheet

## Transaction & Message

| Variable | Type | Description |
|----------|------|-------------|
| `msg.data` | `bytes calldata` | Complete call data |
| `msg.sender` | `address` | Sender of current call |
| `msg.sig` | `bytes4` | First 4 bytes of call data (function selector) |
| `msg.value` | `uint256` | Wei sent with call |
| `tx.gasprice` | `uint256` | Gas price of transaction |
| `tx.origin` | `address` | Original transaction sender |
| `gasleft()` | `uint256` | Remaining gas |

## Block Info

| Variable | Type | Description |
|----------|------|-------------|
| `block.basefee` | `uint256` | Base fee per gas (EIP-1559) |
| `block.chainid` | `uint256` | Current chain ID |
| `block.coinbase` | `address payable` | Current block miner |
| `block.difficulty` | `uint256` | Current block difficulty |
| `block.gaslimit` | `uint256` | Block gas limit |
| `block.number` | `uint256` | Current block number |
| `block.prevrandao` | `uint256` | Random value (post-merge) |
| `block.timestamp` | `uint256` | Block timestamp (seconds) |

## ABI Encoding

```solidity
// Encoding
bytes memory encoded = abi.encode(1, "hello", true);
bytes memory packed = abi.encodePacked("hello", "world");
bytes memory encodedWithSelector = abi.encodeWithSelector(
    bytes4(keccak256("transfer(address,uint256)")),
    recipient,
    amount
);
bytes memory encodedWithSignature = abi.encodeWithSignature(
    "transfer(address,uint256)",
    recipient,
    amount
);

// Decoding
(uint256 a, string memory b) = abi.decode(encoded, (uint256, string));
```

## Cryptographic Functions

```solidity
// Keccak256 (SHA-3 variant)
bytes32 hash = keccak256(abi.encodePacked(a, b));

// SHA256
bytes32 hash = sha256(abi.encodePacked(a, b));

// RIPEMD160
bytes20 hash = ripemd160(abi.encodePacked(a, b));

// Recover signer from signature
address signer = ecrecover(hash, v, r, s);

// Verify signature
function verify(
    bytes32 _hash,
    bytes memory _signature,
    address _signer
) public pure returns (bool) {
    bytes32 ethHash = keccak256(
        abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash)
    );
    (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);
    return ecrecover(ethHash, v, r, s) == _signer;
}
```

## Contract Info

```solidity
address(this)           // Current contract address
address(this).balance   // Contract balance
this.functionName       // Current function selector

// Self destruct
selfdestruct(payable(recipient)); // Send balance and destroy
```

## Type Info

```solidity
// Type minimum/maximum
uint256 max = type(uint256).max;  // 2^256 - 1
int256 min = type(int256).min;    // -2^255

// Contract type
uint256 size = type(MyContract).creationCode.length;
bytes memory code = type(MyContract).runtimeCode;
```

## Memory Operations

```solidity
// Allocate memory
uint256[] memory arr = new uint256[](10);

// Memory position
uint256 ptr;
assembly {
    ptr := mload(0x40)  // Free memory pointer
}

// Load/store in assembly
assembly {
    let value := mload(ptr)    // Load from memory
    mstore(ptr, value)         // Store to memory
    let calldataValue := calldataload(4)  // Load from calldata
}
```

## Common Patterns

```solidity
// Access control
modifier onlyEOA() {
    require(tx.origin == msg.sender, "No contracts");
    _;
}

// Time-based
modifier onlyAfter(uint256 _time) {
    require(block.timestamp >= _time, "Too early");
    _;
}

// Random (not secure for production!)
function pseudoRandom() private view returns (uint256) {
    return uint256(keccak256(abi.encodePacked(
        block.prevrandao,
        block.timestamp,
        msg.sender
    )));
}

// Chain ID verification (prevent replay attacks)
uint256 currentChainId = block.chainid;
```

## Gas & Memory

```solidity
// Free memory pointer location
uint256 constant FREE_MEM_PTR = 0x40;

// Zero address
address constant ZERO_ADDRESS = address(0);

// Max values
uint256 constant MAX_UINT = type(uint256).max;
uint256 constant MAX_INT = type(int256).max;
```