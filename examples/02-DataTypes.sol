pragma solidity ^0.8.19;

// SPDX-License-Identifier: MIT
// Data Types and Variables

contract DataTypes {
    // ============================================
    // VALUE TYPES
    // ============================================
    
    // Boolean
    bool public isActive = true;
    
    // Integers
    uint256 public positiveNumber = 100;           // Unsigned (0 to 2^256-1)
    int256 public signedNumber = -100;           // Signed (-2^255 to 2^255-1)
    
    // Fixed-size integers
    uint8 public smallNumber = 255;              // 0 to 255
    uint16 public mediumNumber = 65535;          // 0 to 65535
    uint32 public largeNumber = 4294967295;      // 0 to 2^32-1
    
    // IMPORTANT: Checked arithmetic by default in 0.8.x
    // Overflow/underflow reverts automatically
    
    // Address types
    address public owner;                        // 20-byte Ethereum address
    address payable public payableOwner;         // Can receive ETH
    
    // Address operations
    function getBalance(address _addr) public view returns (uint256) {
        return _addr.balance;                    // Check balance in wei
    }
    
    function sendEther(address payable _recipient, uint256 _amount) public {
        (bool success, ) = _recipient.call{value: _amount}("");
        require(success, "Transfer failed");
    }
    
    // Bytes
    bytes32 public fixedBytes = "Hello";         // Fixed-size, most efficient
    bytes public dynamicBytes;                    // Dynamic-size, more gas
    
    // String
    string public text = "Solidity";
    
    // Enum
    enum Status { Pending, Active, Inactive }
    Status public currentStatus = Status.Pending;
    
    // ============================================
    // REFERENCE TYPES
    // ============================================
    
    // Arrays
    uint256[] public numbers;                    // Dynamic array
    uint256[5] public fixedNumbers;            // Fixed-size array
    
    // Mappings
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowances;
    
    // Structs
    struct Person {
        string name;
        uint256 age;
        address wallet;
    }
    
    Person public person;
    
    // ============================================
    // DATA LOCATIONS
    // ============================================
    
    // storage - persistent, costs gas
    // memory - temporary, function lifetime
    // calldata - read-only function arguments (external functions)
    
    function processArray(uint256[] calldata _data) external pure returns (uint256) {
        // calldata is cheaper for external function arguments
        return _data.length;
    }
    
    function createInMemory() public pure returns (uint256[] memory) {
        // memory is temporary
        uint256[] memory temp = new uint256[](3);
        temp[0] = 1;
        return temp;
    }
}

// Type Aliases for clarity
type Decimal18 is uint256;  // Custom type for 18-decimal numbers
