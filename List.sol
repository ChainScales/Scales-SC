pragma solidity ^0.8.15;

import './libs/context.sol';
import './libs/ownable.sol';
import './libs/address.sol';
import './libs/SafeERC20.sol';

//SPDX-License-Identifier: Unlicense

contract ChainScales is Ownable {

    address payable public recipient; // Address for dividend contract, not replaceable
    uint256 public price;

    constructor(
        address payable _recipient, 
        uint256 _price
    ) {
       recipient = _recipient;
       price = _price;
    }
    
    struct units {
        string hash; // document
        address owner; // owner
        uint creation;  // timestamp
    }

    units[] internal inventionList;

    /* 
       Main setter
       You can add a non - unique value but getter will return only the first owner
    */

    function RegisterNewDocument (string memory NewHash) external payable returns (uint) {

        if (msg.value < price) { 
            revert("Value is smaller than token price");
        }

        address _owner = msg.sender;
        uint _creation = block.timestamp;
        inventionList.push(units(NewHash, _owner, _creation));
        return inventionList.length - 1;

    }

    /* 
        Working with revenue
    */

    function GetBalance () external view returns (uint) {
        return address(this).balance;
    }

    function WithdrawBalance () external onlyOwner {
        recipient.transfer(address(this).balance);
    }

    /*
        Working with price 
    */

    function UpdatePrice (uint newPrice) external onlyOwner {
        price = newPrice;
    }

    function GetPrice () external view returns (uint) {
        return price;
    }

    /* 
       Document can be transferred to a new owner
    */

    function DocumentTransfer (uint _id, address _newOwner) external returns (uint) {
        if (_id > inventionList.length - 1) revert("Called id not exist");
        if (inventionList[_id].owner != msg.sender) revert("Caller is not a document's owner");

        inventionList[_id].owner = _newOwner;
        return 1;
    }

    /*
        Change address for receiving a tokens 
    */

    /* function SetupRecirient (address _newRecirient) external onlyOwner {
        recipient = _newRecirient;
    } */

    // Getters

    function GetDataByHash (string memory _hash) public view returns (units memory) {

         for (uint256 i = 0; i < inventionList.length; i++) {

            if (keccak256(bytes(inventionList[i].hash)) == keccak256(bytes(_hash))) {
                return inventionList[i];
            }
        }

        revert("Hash not found");
    }
    
    function GetHashesByOwner (address _owner) public view returns (units[] memory) {

        uint256 counter = 0;

        for (uint256 i = 0; i < inventionList.length; i++) {
            if (inventionList[i].owner == _owner) {
                counter++;
            }
        }

        units[] memory filteredInventions = new units[](counter);
        uint256 index = 0;

        for (uint j = 0; j < inventionList.length; j++) {
           if (inventionList[j].owner == _owner) {
              filteredInventions[index] = inventionList[j];
              index++;
           }
        } 
        return filteredInventions;
    }

    function GetHashById (uint _id) public view returns (units memory) {
        return inventionList[_id];
    }

    function GetHashId(string memory hash) public view returns (uint) {
        bytes32 comV = keccak256(bytes(hash));
        for (uint256 i = 0; i < inventionList.length; i++) {
          if (keccak256(bytes(inventionList[i].hash)) == comV) {
            return i;
          }
        }
        revert("Hash not found"); 
    }
    
}