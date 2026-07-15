pragma solidity ^0.8.19;

// SPDX-License-Identifier: MIT
// Functions and Visibility

contract Functions {
    uint256 public value;
    
    // ============================================
    // VISIBILITY
    // ============================================
    
    // public - callable from anywhere
    // private - only within this contract
    // internal - within contract and derived contracts
    // external - only from outside (cheaper than public)
    
    function publicFunction() public {
        value = 1;
    }
    
    function privateFunction() private {
        value = 2;
    }
    
    function internalFunction() internal {
        value = 3;
    }
    
    function externalFunction() external {
        value = 4;
    }
    
    // ============================================
    // STATE MUTABILITY
    // ============================================
    
    // view - reads state, doesn't modify
    function getValue() public view returns (uint256) {
        return value;
    }
    
    // pure - doesn't read or modify state
    function add(uint256 a, uint256 b) public pure returns (uint256) {
        return a + b;
    }
    
    // payable - can receive ETH
    function deposit() public payable {
        require(msg.value > 0, "Send ETH");
    }
    
    // ============================================
    // FUNCTION PARAMETERS
    // ============================================
    
    // Input and output parameters
    function transform(uint256 _input) 
        public 
        pure 
        returns (uint256 doubled, uint256 tripled) 
    {
        doubled = _input * 2;
        tripled = _input * 3;
        // return (doubled, tripled); // Optional explicit return
    }
    
    // Named return values
    function calculate(uint256 _amount) 
        public 
        pure 
        returns (uint256 fee, uint256 net) 
    {
        fee = (_amount * 350) / 10000;    // 3.5% fee
        net = _amount - fee;
    }
    
    // ============================================
    // FUNCTION MODIFIERS
    // ============================================
    
    address public owner = msg.sender;
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _; // Execute function body here
    }
    
    modifier validAddress(address _addr) {
        require(_addr != address(0), "Zero address");
        _;
    }
    
    modifier nonZero(uint256 _amount) {
        require(_amount > 0, "Zero amount");
        _;
    }
    
    function restrictedAction() public onlyOwner {
        // Only owner can execute
        value = 100;
    }
    
    function transfer(address _to, uint256 _amount) 
        public 
        onlyOwner 
        validAddress(_to) 
        nonZero(_amount) 
    {
        // Transfer logic
    }
    
    // ============================================
    // ADVANCED PATTERNS
    // ============================================
    
    // Reentrancy guard
    bool private locked;
    
    modifier nonReentrant() {
        require(!locked, "Reentrant call");
        locked = true;
        _;
        locked = false;
    }
    
    // Gas optimization: unchecked
    function unsafeIncrement(uint256 x) public pure returns (uint256) {
        unchecked {
            return x + 1; // Won't revert on overflow
        }
    }
    
    // Custom errors (cheaper than require strings)
    error InsufficientBalance(uint256 available, uint256 required);
    error InvalidAddress(address addr);
    
    function checkBalance(uint256 _required) public view {
        if (value < _required) {
            revert InsufficientBalance(value, _required);
        }
    }
}
