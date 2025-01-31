// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "../Ethernaut/Level.sol";
import "./Recovery.sol";

contract RecoveryFactory is Level {
    mapping(address => address) lostAddress;

    function createInstance(address) public payable override returns (address) {
        Recovery recoveryInstance;
        recoveryInstance = new Recovery();
        // create a simple token
        recoveryInstance.generateToken("InitialToken", uint256(100000));
        // the lost address
        lostAddress[address(recoveryInstance)] =
            address(uint160(uint256(keccak256(abi.encodePacked(uint8(0xd6), uint8(0x94), recoveryInstance, uint8(0x01))))));
        // Send it some ether
        (bool result,) = lostAddress[address(recoveryInstance)].call{value: 0.001 ether}("");
        require(result);

        return address(recoveryInstance);
    }

    function validateInstance(address payable _instance, address) public view override returns (bool) {
        return address(lostAddress[_instance]).balance == 0;
    }
}
