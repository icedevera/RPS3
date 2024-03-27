// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {VRFCoordinatorV2Mock} from "@chainlink/contracts/src/v0.8/mocks/VRFCoordinatorV2Mock.sol";
import {Script, console} from "forge-std/Script.sol";

contract FullfillRandomWordsScript is Script {
    VRFCoordinatorV2Mock public vrfCoordinator;

    function setUp() public {}

    function run() public {
        address vrfCoordinatorAddress = vm.envAddress(
            "LOCAL_DEV_VRF_COORDINATOR_V2_MOCK_ADDRESS"
        );
        address vrfWrapperAddress = vm.envAddress(
            "LOCAL_DEV_VRF_V2_WRAPPER_ADDRESS"
        );
        uint requestId = vm.envUint("LOCAL_DEV_REQUEST_ID");
        uint privateKey = vm.envUint("LOCAL_DEV_ANVIL_PRIVATE_KEY");

        vm.startBroadcast(privateKey);

        uint256 mockRandomNumber = 0; // Should result in ROCK
        uint256[] memory randomWords = new uint256[](1);
        randomWords[0] = mockRandomNumber;

        vrfCoordinator = VRFCoordinatorV2Mock(vrfCoordinatorAddress);
        vrfCoordinator.fulfillRandomWordsWithOverride(
            uint256(requestId),
            address(vrfWrapperAddress),
            randomWords
        );

        vm.stopBroadcast();
    }
}
