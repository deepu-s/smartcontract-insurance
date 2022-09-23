//SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract HealthInsurance {
    address admin;
    struct citizen {
        bool isuidGenerated;
        string name;
        uint insuredAmount;
    }
    mapping(address => citizen) public citizenMapping;
    mapping(address => bool) public doctorMapping;

    constructor(){
        admin = msg.sender;
    }
    modifier onlyAdmin(){
        require(admin == msg.sender);
        _;
    }

    function setDoctor(address _doctorAddress) public onlyAdmin {
        require(!doctorMapping[_doctorAddress]);
        doctorMapping[_doctorAddress] = true;
    }

    function setCitezenData(string memory _name, uint _insureAmount) public onlyAdmin returns (address) {
        address uniqueId = address(bytes20(sha256(abi.encodePacked(msg.sender,block.timestamp))));
        require(!citizenMapping[uniqueId].isuidGenerated);

        citizenMapping[uniqueId].isuidGenerated = true;
        citizenMapping[uniqueId].name = _name;
        citizenMapping[uniqueId].insuredAmount =  _insureAmount;

        return uniqueId;
    }

    function claimInsurance(address _uniqueId, uint _usedAmount) public returns (string memory) {
        require(doctorMapping[msg.sender]);
        if(citizenMapping[_uniqueId].insuredAmount <= _usedAmount){
            return "Amount is not available.";
        }
        citizenMapping[_uniqueId].insuredAmount -= _usedAmount;
        return "Insurance has been successfully claimed.";
    }
}