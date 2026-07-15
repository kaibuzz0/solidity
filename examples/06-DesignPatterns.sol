pragma solidity ^0.8.19;

// SPDX-License-Identifier: MIT
// Simple Storage Pattern

contract SimpleStorage {
    uint256 private value;
    address public owner;
    
    event ValueChanged(uint256 oldValue, uint256 newValue);
    
    constructor() {
        owner = msg.sender;
    }
    
    function store(uint256 _value) public {
        uint256 oldValue = value;
        value = _value;
        emit ValueChanged(oldValue, _value);
    }
    
    function retrieve() public view returns (uint256) {
        return value;
    }
}

// ============================================
// FACTORY PATTERN
// ============================================

contract Factory {
    address[] public deployedContracts;
    
    event ContractCreated(address contractAddress, uint256 index);
    
    function createSimpleStorage() public {
        SimpleStorage newContract = new SimpleStorage();
        deployedContracts.push(address(newContract));
        emit ContractCreated(address(newContract), deployedContracts.length - 1);
    }
    
    function getDeployedContracts() public view returns (address[] memory) {
        return deployedContracts;
    }
    
    function getContractCount() public view returns (uint256) {
        return deployedContracts.length;
    }
}

// ============================================
// PROXY PATTERN (Basic)
// ============================================

contract Proxy {
    address public implementation;
    address public admin;
    
    constructor(address _implementation) {
        implementation = _implementation;
        admin = msg.sender;
    }
    
    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }
    
    function upgrade(address _newImplementation) public onlyAdmin {
        implementation = _newImplementation;
    }
    
    fallback() external payable {
        address _impl = implementation;
        require(_impl != address(0));
        
        assembly {
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize())
            let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)
            let size := returndatasize()
            returndatacopy(ptr, 0, size)
            
            switch result
            case 0 { revert(ptr, size) }
            default { return(ptr, size) }
        }
    }
    
    receive() external payable {}
}

// ============================================
// ACCESS CONTROL
// ============================================

contract AccessControl {
    mapping(address => bool) public admins;
    mapping(address => mapping(bytes32 => bool)) public roles;
    
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER");
    bytes32 public constant BURNER_ROLE = keccak256("BURNER");
    
    event RoleGranted(bytes32 indexed role, address indexed account);
    event RoleRevoked(bytes32 indexed role, address indexed account);
    
    constructor() {
        _grantRole(ADMIN_ROLE, msg.sender);
    }
    
    modifier onlyRole(bytes32 role) {
        require(hasRole(role, msg.sender), "Missing role");
        _;
    }
    
    function hasRole(bytes32 role, address account) public view returns (bool) {
        return roles[account][role];
    }
    
    function _grantRole(bytes32 role, address account) internal {
        roles[account][role] = true;
        emit RoleGranted(role, account);
    }
    
    function grantRole(bytes32 role, address account) public onlyRole(ADMIN_ROLE) {
        _grantRole(role, account);
    }
    
    function revokeRole(bytes32 role, address account) public onlyRole(ADMIN_ROLE) {
        roles[account][role] = false;
        emit RoleRevoked(role, account);
    }
}

// ============================================
// PULL OVER PUSH (Payment Pattern)
// ============================================

contract PullPayment {
    mapping(address => uint256) public payments;
    
    event PaymentReceived(address from, uint256 amount);
    event PaymentWithdrawn(address to, uint256 amount);
    
    function deposit() public payable {
        payments[msg.sender] += msg.value;
        emit PaymentReceived(msg.sender, msg.value);
    }
    
    function withdraw() public {
        uint256 payment = payments[msg.sender];
        require(payment > 0, "No funds");
        
        payments[msg.sender] = 0;
        
        (bool success, ) = payable(msg.sender).call{value: payment}("");
        require(success, "Transfer failed");
        
        emit PaymentWithdrawn(msg.sender, payment);
    }
    
    function getBalance() public view returns (uint256) {
        return payments[msg.sender];
    }
}
