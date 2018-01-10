pragma solidity ^0.4.18;

contract PublicContract {

    uint public _data;

    function addToPublicContract(uint data) public {
        _data = data;
    }
}