pragma solidity ^0.6.0;

contract MyFirstContract {
       string private name; 
       uint private age;

       function setName (string newName){
           name = newName;
       }

       function getName() returns (string){
           return name;
       }

       function setAge() returns (uint newAge) {
           return newAge;
       }

       function getAge () returns (uint) {
           return age;
       }


}

