pragma solidity ^0.8.19;

// SPDX-License-Identifier: MIT
// Security Best Practices

contract SecurityExamples {
    // ============================================
    // 1. REENTRANCY PROTECTION
    // ============================================
    
    mapping(address => uint256) public balances;
    bool private locked;
    
    modifier nonReentrant() {
        require(!locked, "Reentrant call");
        locked = true;
        _;
        locked = false;
    }
    
    // WRONG: Vulnerable to reentrancy
    function withdrawVulnerable() public {
        uint256 amount = balances[msg.sender];
        require(amount > 0);
        (bool success, ) = msg.sender.call{value: amount}(""); // External call first!
        require(success);
        balances[msg.sender] = 0; // State update after external call
    }
    
    // CORRECT: Checks-Effects-Interactions pattern
    function withdrawSecure() public nonReentrant {
        uint256 amount = balances[msg.sender];
        require(amount > 0, "No balance");
        
        // 1. CHECKS (require statements)
        // 2. EFFECTS (state changes)
        balances[msg.sender] = 0;
        
        // 3. INTERACTIONS (external calls)
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");
    }
    
    // ============================================
    // 2. INTEGER OVERFLOW (0.8.x handles this)
    // ============================================
    
    // In 0.8.x, overflow/underflow reverts automatically
    // No need for SafeMath!
    
    function addSafe(uint256 a, uint256 b) public pure returns (uint256) {
        return a + b; // Will revert on overflow
    }
    
    // Use unchecked for intentional overflow (gas savings)
    function unsafeIncrement(uint256 x) public pure returns (uint256) {
        unchecked {
            return x + 1; // Can overflow, won't revert
        }
    }
    
    // ============================================
    // 3. ACCESS CONTROL
    // ============================================
    
    address public owner;
    bool public paused;
    
    error NotOwner();
    error ContractPaused();
    
    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }
    
    modifier whenNotPaused() {
        if (paused) revert ContractPaused();
        _;
    }
    
    constructor() {
        owner = msg.sender;
    }
    
    function criticalFunction() public onlyOwner whenNotPaused {
        // Only owner can call, and only when not paused
    }
    
    function pause() public onlyOwner {
        paused = true;
    }
    
    function unpause() public onlyOwner {
        paused = false;
    }
    
    // ============================================
    // 4. INPUT VALIDATION
    // ============================================
    
    function validateAddress(address _addr) public pure {
        require(_addr != address(0), "Zero address");
    }
    
    function validateAmount(uint256 _amount, uint256 _min, uint256 _max) public pure {
        require(_amount >= _min, "Below minimum");
        require(_amount <= _max, "Exceeds maximum");
    }
    
    // ============================================
    // 5. EVENT EMITTING (For Transparency)
    // ============================================
    
    event CriticalAction(address indexed performer, uint256 indexed value, string reason);
    
    function performCriticalAction(uint256 _value, string memory _reason) public onlyOwner {
        emit CriticalAction(msg.sender, _value, _reason);
        // Perform action
    }
    
    // ============================================
    // 6. RANDOMNESS (Blockchain is deterministic!)
    // ============================================
    
    // WRONG: Predictable randomness
    function badRandom() public view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender)));
    }
    
    // Use Chainlink VRF for secure randomness
    // https://docs.chain.link/vrf
    
    // ============================================
    // 7. GAS OPTIMIZATIONS
    // ============================================
    
    // Pack variables (order by size)
    uint128 public balance;    // 16 bytes
    uint128 public allowance;  // 16 bytes - packed with balance
    uint256 public data;       // 32 bytes - separate slot
    
    // Use calldata for read-only external functions
    function processExternal(uint256[] calldata data_) external pure returns (uint256) {
        return data_.length;
    }
    
    // Cache array length in loops
    function sumArray(uint256[] memory arr) public pure returns (uint256) {
        uint256 sum = 0;
        uint256 len = arr.length; // Cache length
        for (uint256 i = 0; i < len; ) {
            sum += arr[i];
            unchecked { i++; } // Cheaper increment
        }
        return sum;
    }
    
    // Short circuit
    function checkBoth(uint256 x, uint256 y) public pure returns (bool) {
        // If x > 10 is false, expensive() won't be called
        return x > 10 || expensive(y);
    }
    
    function expensive(uint256) public pure returns (bool) {
        return true;
    }
}

// ============================================
// SECURE PAYMENT CHANNEL
// ============================================

contract SecurePaymentChannel {
    address public sender;
    address public recipient;
    uint256 public expiration;
    mapping(bytes32 => bool) public usedHashes;
    
    event ChannelOpened(address sender, address recipient, uint256 amount);
    event ChannelClosed(uint256 amount);
    event ChannelRefunded();
    
    constructor(address _recipient) payable {
        require(msg.value > 0, "Send ETH");
        sender = msg.sender;
        recipient = _recipient;
        expiration = block.timestamp + 7 days;
        emit ChannelOpened(sender, recipient, msg.value);
    }
    
    function close(uint256 _amount, bytes memory _signature) public {
        require(msg.sender == recipient, "Not recipient");
        require(_amount <= address(this).balance, "Insufficient funds");
        
        bytes32 hash = keccak256(abi.encodePacked(_amount, address(this)));
        bytes32 ethSignedHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
        
        require(recoverSigner(ethSignedHash, _signature) == sender, "Invalid signature");
        
        payable(recipient).transfer(_amount);
        emit ChannelClosed(_amount);
        
        selfdestruct(payable(sender));
    }
    
    function refund() public {
        require(msg.sender == sender, "Not sender");
        require(block.timestamp >= expiration, "Not expired");
        
        emit ChannelRefunded();
        selfdestruct(payable(sender));
    }
    
    function recoverSigner(bytes32 _hash, bytes memory _signature) internal pure returns (address) {
        require(_signature.length == 65, "Invalid signature length");
        
        bytes32 r;
        bytes32 s;
        uint8 v;
        
        assembly {
            r := mload(add(_signature, 32))
            s := mload(add(_signature, 64))
            v := byte(0, mload(add(_signature, 96)))
        }
        
        return ecrecover(_hash, v, r, s);
    }
}
