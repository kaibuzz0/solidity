pragma solidity ^0.8.19;

// SPDX-License-Identifier: MIT
// Control Structures

contract ControlStructures {
    uint256 public result;
    
    // ============================================
    // CONDITIONALS
    // ============================================
    
    function ifElse(uint256 _x) public pure returns (string memory) {
        if (_x > 10) {
            return "Greater than 10";
        } else if (_x == 10) {
            return "Equal to 10";
        } else {
            return "Less than 10";
        }
    }
    
    // Ternary operator
    function ternary(uint256 _x) public pure returns (string memory) {
        return _x > 10 ? "Big" : "Small";
    }
    
    // Short-circuit evaluation
    function check(uint256 _x) public pure returns (bool) {
        // || stops if first is true
        // && stops if first is false
        return (_x > 10) || expensiveCheck(_x);
    }
    
    function expensiveCheck(uint256) public pure returns (bool) {
        // Simulated expensive operation
        return true;
    }
    
    // ============================================
    // LOOPS
    // ============================================
    
    // For loop
    function sumArray(uint256[] memory _arr) public pure returns (uint256) {
        uint256 sum = 0;
        for (uint256 i = 0; i < _arr.length; i++) {
            sum += _arr[i];
        }
        return sum;
    }
    
    // While loop (less common, same gas cost)
    function sumWithWhile(uint256[] memory _arr) public pure returns (uint256) {
        uint256 sum = 0;
        uint256 i = 0;
        while (i < _arr.length) {
            sum += _arr[i];
            i++;
        }
        return sum;
    }
    
    // Do-while loop
    function atLeastOnce() public pure returns (uint256) {
        uint256 count = 0;
        do {
            count++;
        } while (count < 0); // Executes at least once
        return count;
    }
    
    // Unchecked loop for gas savings
    function gasEfficientSum(uint256[] memory _arr) public pure returns (uint256) {
        uint256 sum = 0;
        uint256 len = _arr.length; // Cache length
        
        for (uint256 i = 0; i < len; ) {
            sum += _arr[i];
            unchecked { i++; } // Cheaper increment
        }
        return sum;
    }
    
    // ============================================
    // ERROR HANDLING
    // ============================================
    
    // Require - reverts if false
    function requireCheck(uint256 _amount) public pure {
        require(_amount > 0, "Amount must be > 0");
        require(_amount < 1000, "Amount too large");
    }
    
    // Assert - for internal errors (should never fail)
    function assertCheck(uint256 _a, uint256 _b) public pure {
        uint256 result = _a + _b;
        assert(result >= _a); // Should always be true in 0.8.x
    }
    
    // Revert with custom error
    error InvalidAmount(uint256 provided, uint256 max);
    
    function revertExample(uint256 _amount) public pure {
        if (_amount > 1000) {
            revert InvalidAmount(_amount, 1000);
        }
    }
    
    // Try-catch (external calls only)
    function tryCatchExample(address _target) public returns (bool) {
        (bool success, ) = _target.call(abi.encodeWithSignature("doSomething()"));
        
        if (!success) {
            // Handle failure
            return false;
        }
        return true;
    }
    
    // ============================================
    // BREAK AND CONTINUE
    // ============================================
    
    function findFirst(uint256[] memory _arr, uint256 _target) 
        public 
        pure 
        returns (uint256) 
    {
        for (uint256 i = 0; i < _arr.length; i++) {
            if (_arr[i] == _target) {
                return i; // Exit early
            }
        }
        return type(uint256).max; // Not found
    }
    
    function sumEvenOnly(uint256[] memory _arr) public pure returns (uint256) {
        uint256 sum = 0;
        for (uint256 i = 0; i < _arr.length; i++) {
            if (_arr[i] % 2 != 0) {
                continue; // Skip odd numbers
            }
            sum += _arr[i];
        }
        return sum;
    }
}
