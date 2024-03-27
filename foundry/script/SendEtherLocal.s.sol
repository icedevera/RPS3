// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";

contract SendEtherLocalScript is Script {
    function setUp() public {}

    function run() public {
        uint privateKey = vm.envUint("LOCAL_DEV_ANVIL_PRIVATE_KEY");
        address localDevAddress = vm.envAddress("LOCAL_DEV_ADDRESS");

        vm.startBroadcast(privateKey);

        payable(localDevAddress).transfer(100 ether);

        vm.stopBroadcast();
    }
}
