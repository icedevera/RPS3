// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {RockPaperScissors} from "../src/RockPaperScissors.sol";
import {VRFCoordinatorV2Mock} from "@chainlink/contracts/src/v0.8/mocks/VRFCoordinatorV2Mock.sol";
import {MockV3Aggregator} from "@chainlink/contracts/src/v0.8/tests/MockV3Aggregator.sol";
import {MockLinkToken} from "@chainlink/contracts/src/v0.8/mocks/MockLinkToken.sol";
import {VRFV2Wrapper} from "@chainlink/contracts/src/v0.8/VRFV2Wrapper.sol";
import {Script, console} from "forge-std/Script.sol";

contract LocalDeploymentScript is Script {
    RockPaperScissors public rockPaperScissors;
    VRFCoordinatorV2Mock public vrfCoordinator;
    MockLinkToken public linkToken;
    MockV3Aggregator public linkEthFeed;
    VRFV2Wrapper public vrfWrapper;

    uint256 public constant entryFees = 0.001 ether;
    int256 public constant linkEthPrice = 3000000000000000;
    uint8 public constant decimals = 18;

    function setUp() public {}

    function deployContracts() public {
        // Deploy Mock Contracts
        uint96 baseFee = 100000000000000000;
        uint96 gasPriceLink = 1000000000;
        console.log("Deploying VRFCoordinatorV2Mock...");
        vrfCoordinator = new VRFCoordinatorV2Mock(baseFee, gasPriceLink);
        console.log("VRFCoordinatorV2Mock address: ", address(vrfCoordinator));
        console.log("Deploying MockLinkToken...");
        linkToken = new MockLinkToken();
        console.log("MockLinkToken address: ", address(linkToken));
        console.log("Deploying MockV3Aggregator...");
        linkEthFeed = new MockV3Aggregator(decimals, linkEthPrice);
        console.log("MockV3Aggregator address: ", address(linkEthFeed));

        // Set up and configure VRFV2Wrapper
        console.log("Deploying VRFV2Wrapper...");
        vrfWrapper = new VRFV2Wrapper(
            address(linkToken),
            address(linkEthFeed),
            address(vrfCoordinator)
        );
        console.log("VRFV2Wrapper address: ", address(vrfWrapper));

        // Configuration parameters for VRFV2Wrapper
        uint32 wrapperGasOverhead = 60000;
        uint32 coordinatorGasOverhead = 52000;
        uint8 wrapperPremiumPercentage = 10;
        bytes32 keyHash = 0xd89b2bf150e3b9e13446986e571fb9cab24b13cea0a43ea20a6049a85cc807cc;
        uint8 maxNumWords = 10;

        // Call setConfig function
        vrfWrapper.setConfig(
            wrapperGasOverhead,
            coordinatorGasOverhead,
            wrapperPremiumPercentage,
            keyHash,
            maxNumWords
        );

        // Fund the VRFv2Wrapper subscription
        console.log("Funding VRFv2Wrapper subscription...");
        vrfCoordinator.fundSubscription(
            vrfWrapper.SUBSCRIPTION_ID(),
            10000000000000000000
        );

        // Deploy RockPaperScissors contract
        console.log("Deploying RockPaperScissors...");
        rockPaperScissors = new RockPaperScissors(
            address(linkToken),
            address(vrfWrapper)
        );
        console.log("RockPaperScissors address: ", address(rockPaperScissors));

        // Fund RockPaperScissors contract with LINK tokens
        console.log("Funding RockPaperScissors contract...");
        linkToken.transfer(address(rockPaperScissors), 10000000000000000000);
    }

    function run() public {
        uint privateKey = vm.envUint("LOCAL_DEV_ANVIL_PRIVATE_KEY");

        vm.startBroadcast(privateKey);

        deployContracts();

        // Fund RockPaperScissors contract with ETH
        console.log("Funding RockPaperScissors contract with ETH...");
        payable(rockPaperScissors).transfer(10 ether);

        vm.stopBroadcast();
    }
}
