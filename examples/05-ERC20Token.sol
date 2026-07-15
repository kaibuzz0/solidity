pragma solidity ^0.8.19;

// SPDX-License-Identifier: MIT
// ERC-20 Token Standard Implementation

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

contract SimpleToken is IERC20 {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    
    uint256 private _totalSupply;
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    
    address public owner;
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }
    
    constructor(string memory name_, string memory symbol_, uint256 initialSupply) {
        _name = name_;
        _symbol = symbol_;
        _decimals = 18;
        owner = msg.sender;
        
        _mint(msg.sender, initialSupply * 10 ** _decimals);
    }
    
    function name() public view returns (string memory) {
        return _name;
    }
    
    function symbol() public view returns (string memory) {
        return _symbol;
    }
    
    function decimals() public view returns (uint8) {
        return _decimals;
    }
    
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }
    
    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }
    
    function transfer(address to, uint256 amount) public override returns (bool) {
        address from = msg.sender;
        _transfer(from, to, amount);
        return true;
    }
    
    function allowance(address _owner, address spender) public view override returns (uint256) {
        return _allowances[_owner][spender];
    }
    
    function approve(address spender, uint256 amount) public override returns (bool) {
        address from = msg.sender;
        _approve(from, spender, amount);
        return true;
    }
    
    function transferFrom(address from, address to, uint256 amount) public override returns (bool) {
        address spender = msg.sender;
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }
    
    function _transfer(address from, address to, uint256 amount) internal {
        require(from != address(0), "Transfer from zero");
        require(to != address(0), "Transfer to zero");
        
        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "Insufficient balance");
        
        unchecked {
            _balances[from] = fromBalance - amount;
            _balances[to] += amount;
        }
        
        emit Transfer(from, to, amount);
    }
    
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "Mint to zero");
        
        _totalSupply += amount;
        unchecked {
            _balances[account] += amount;
        }
        
        emit Transfer(address(0), account, amount);
    }
    
    function _approve(address _owner, address spender, uint256 amount) internal {
        require(_owner != address(0), "Approve from zero");
        require(spender != address(0), "Approve to zero");
        
        _allowances[_owner][spender] = amount;
        emit Approval(_owner, spender, amount);
    }
    
    function _spendAllowance(address _owner, address spender, uint256 amount) internal {
        uint256 currentAllowance = allowance(_owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "Insufficient allowance");
            unchecked {
                _approve(_owner, spender, currentAllowance - amount);
            }
        }
    }
    
    // Additional functions
    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }
    
    function _burn(address account, uint256 amount) internal {
        require(account != address(0), "Burn from zero");
        
        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "Insufficient balance");
        
        unchecked {
            _balances[account] = accountBalance - amount;
            _totalSupply -= amount;
        }
        
        emit Transfer(account, address(0), amount);
    }
}
