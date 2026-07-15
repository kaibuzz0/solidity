pragma solidity ^0.8.19;

// SPDX-License-Identifier: MIT
// First Contract Example

contract MyFirstContract {
    // State variables stored on blockchain
    string private name; 
    uint256 private age;
    
    // Event for logging
    event NameChanged(string oldName, string newName);
    event AgeSet(uint256 age);

    // Function to set name
    function setName(string memory newName) public {
        string memory oldName = name;
        name = newName;
        emit NameChanged(oldName, newName);
    }

    // Function to get name
    function getName() public view returns (string memory) {
        return name;
    }

    // Function to set age
    function setAge(uint256 newAge) public {
        age = newAge;
        emit AgeSet(newAge);
    }
    
    // Function to get age
    function getAge() public view returns (uint256) {
        return age;
    }
}

// Key Concepts:
// - State variables persist on blockchain (costs gas to modify)
// - memory keyword for temporary variables
// - view functions don't modify state (free to call)
// - public functions can be called externally
// - private variables are only accessible inside contract
// - events log data for external monitoring
