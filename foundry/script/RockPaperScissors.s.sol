// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {RockPaperScissors} from "../src/RockPaperScissors.sol";
import {Script, console} from "forge-std/Script.sol";

contract RockPaperScissorsScript is Script {
    function setUp() public {}

    function run() public {
        // Get needed environment variables
        uint privateKey = vm.envUint("DEV_PRIVATE_KEY");
        address linkTokenAddress = vm.envAddress("LINK_TOKEN_ADDRESS");
        address vrfWrapperAddress = vm.envAddress("VRF_WRAPPER_ADDRESS");
        // Get account address
        address account = vm.addr(privateKey);
        console.log("Account: ", account);

        vm.startBroadcast(privateKey);
        console.log("Deploying RockPaperScissors...");
        RockPaperScissors rockPaperScissors = new RockPaperScissors{
            value: 1 ether
        }(linkTokenAddress, vrfWrapperAddress);

        console.log("RockPaperScissors address: ", address(rockPaperScissors));
        vm.stopBroadcast();
    }
}
