pragma solidity ^0.4.24;

contract MyContract {

    struct User {
      string name;
      uint level;
    }
    
    mapping (address => User) userStructs;
    
    address[] public userAddresses;
    
    function createUser(string name, uint level) public {
      
      // set User name using our userStructs mapping
      userStructs[msg.sender].name = name;
      // set User level using our userStructs mapping
      userStructs[msg.sender].level = level;
      // push user address into userAddresses array
      userAddresses.push(msg.sender);
    }
    
    function getAllUsers() external view returns (string) {
      return userAddresses[msg.sender].name;
    }

}