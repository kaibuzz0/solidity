pragma solidity ^0.8.19;

// SPDX-License-Identifier: MIT
// Inheritance and Libraries

// ============================================
// INHERITANCE
// ============================================

contract Ownable {
    address public owner;
    
    constructor() {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }
    
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Zero address");
        owner = newOwner;
    }
}

// Single inheritance
contract MyToken is Ownable {
    string public name;
    
    constructor(string memory _name) {
        name = _name;
    }
}

// Multiple inheritance (Order matters for super calls!)
contract Base1 {
    function foo() public pure virtual returns (string memory) {
        return "Base1";
    }
}

contract Base2 {
    function foo() public pure virtual returns (string memory) {
        return "Base2";
    }
}

// Most base-like contract goes first
contract Derived is Base1, Base2 {
    function foo() public pure override(Base1, Base2) returns (string memory) {
        return string(abi.encodePacked(Base1.foo(), Base2.foo()));
    }
}

// ============================================
// VIRTUAL AND OVERRIDE
// ============================================

contract Parent {
    // Virtual allows overriding
    function version() public pure virtual returns (uint256) {
        return 1;
    }
    
    // Virtual with implementation
    function getName() public pure virtual returns (string memory) {
        return "Parent";
    }
}

contract Child is Parent {
    // Must use override
    function version() public pure override returns (uint256) {
        return 2;
    }
    
    // Can call parent with super
    function getName() public pure override returns (string memory) {
        return string(abi.encodePacked("Child of ", super.getName()));
    }
}

// Abstract contract (cannot be deployed)
abstract contract AbstractContract {
    function mustImplement() public pure virtual returns (string memory);
    
    function canCall() public pure returns (string memory) {
        return "Implemented";
    }
}

// Concrete implementation
contract Concrete is AbstractContract {
    function mustImplement() public pure override returns (string memory) {
        return "Implemented";
    }
}

// ============================================
// LIBRARIES
// ============================================

// Library for math operations
library Math {
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }
    
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }
    
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        return (a & b) + (a ^ b) / 2;
    }
}

// Library with storage
library Balances {
    function increase(mapping(address => uint256) storage self, address account, uint256 amount) internal {
        self[account] += amount;
    }
    
    function decrease(mapping(address => uint256) storage self, address account, uint256 amount) internal {
        require(self[account] >= amount, "Insufficient balance");
        self[account] -= amount;
    }
}

// Using library
contract Token {
    using Math for uint256;
    using Balances for mapping(address => uint256);
    
    mapping(address => uint256) public balances;
    
    function compare(uint256 a, uint256 b) public pure returns (uint256) {
        return a.max(b); // Using library as method
    }
    
    function mint(uint256 amount) public {
        balances.increase(msg.sender, amount); // Using storage library
    }
    
    function burn(uint256 amount) public {
        balances.decrease(msg.sender, amount);
    }
}

// ============================================
// USING FOR
// ============================================

library StringUtils {
    function concat(string memory a, string memory b) internal pure returns (string memory) {
        return string(abi.encodePacked(a, b));
    }
    
    function length(string memory s) internal pure returns (uint256) {
        return bytes(s).length;
    }
}

contract StringExample {
    using StringUtils for string; // Direct type binding
    
    function combine(string memory a, string memory b) public pure returns (string memory) {
        return a.concat(b); // Can call as method
    }
    
    function getLength(string memory s) public pure returns (uint256) {
        return s.length();
    }
}

// ============================================
// INTERFACES
// ============================================

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// Using interface
contract TokenInteraction {
    IERC20 public token;
    
    constructor(address _token) {
        token = IERC20(_token);
    }
    
    function checkBalance(address _account) public view returns (uint256) {
        return token.balanceOf(_account);
    }
}

// ============================================
// COMMON PATTERNS
// ============================================

// Pull over Push
contract PullPayment {
    mapping(address => uint256) public payments;
    
    function deposit() public payable {
        payments[msg.sender] += msg.value;
    }
    
    function withdraw() public {
        uint256 payment = payments[msg.sender];
        require(payment > 0, "No funds");
        
        payments[msg.sender] = 0; // Update before transfer
        
        (bool success, ) = payable(msg.sender).call{value: payment}("");
        require(success, "Transfer failed");
    }
}

// Checks-Effects-Interactions
contract SafeTransfer {
    mapping(address => uint256) public balances;
    
    function transfer(address _to, uint256 _amount) public {
        // 1. CHECKS
        require(_to != address(0), "Zero address");
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        
        // 2. EFFECTS
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
        
        // 3. INTERACTIONS (external calls last)
        emit Transfer(msg.sender, _to, _amount);
    }
    
    event Transfer(address indexed from, address indexed to, uint256 amount);
}

// Mortal (self-destruct)
contract Mortal is Ownable {
    function destroy() public onlyOwner {
        selfdestruct(payable(owner));
    }
}

// Circuit Breaker
contract CircuitBreaker {
    bool public stopped = false;
    address public owner = msg.sender;
    
    modifier stopInEmergency() {
        require(!stopped, "Emergency stop");
        _;
    }
    
    modifier onlyInEmergency() {
        require(stopped, "Not emergency");
        _;
    }
    
    function toggleEmergency() public {
        require(msg.sender == owner, "Not owner");
        stopped = !stopped;
    }
    
    function normalFunction() public stopInEmergency {
        // Normal operation
    }
    
    function emergencyWithdraw() public onlyInEmergency {
        // Emergency only
        payable(owner).transfer(address(this).balance);
    }
}
