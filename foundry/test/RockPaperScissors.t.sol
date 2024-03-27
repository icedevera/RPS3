// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {RockPaperScissors} from "../src/RockPaperScissors.sol";
import {LocalDeploymentScript} from "../script/LocalDeployment.s.sol";
import {VRFCoordinatorV2Mock} from "@chainlink/contracts/src/v0.8/mocks/VRFCoordinatorV2Mock.sol";
import {MockV3Aggregator} from "@chainlink/contracts/src/v0.8/tests/MockV3Aggregator.sol";
import {MockLinkToken} from "@chainlink/contracts/src/v0.8/mocks/MockLinkToken.sol";
import {VRFV2Wrapper} from "@chainlink/contracts/src/v0.8/VRFV2Wrapper.sol";

contract RockPaperScissorsTest is Test {
    RockPaperScissors public rockPaperScissors;
    VRFCoordinatorV2Mock public vrfCoordinator;
    MockLinkToken public linkToken;
    MockV3Aggregator public linkEthFeed;
    VRFV2Wrapper public vrfWrapper;

    LocalDeploymentScript public localDeploymentScript;

    uint256 public constant entryFees = 0.001 ether;

    function setUp() public {
        localDeploymentScript = new LocalDeploymentScript();
        localDeploymentScript.deployContracts();

        // Deploy Mock Contracts
        vrfCoordinator = localDeploymentScript.vrfCoordinator();
        linkToken = localDeploymentScript.linkToken();
        linkEthFeed = localDeploymentScript.linkEthFeed();
        vrfWrapper = localDeploymentScript.vrfWrapper();

        // Deploy RockPaperScissors contract
        rockPaperScissors = localDeploymentScript.rockPaperScissors();

        vm.deal(address(rockPaperScissors), 10 ether); // Allocating 10 ETH to the contract for gas and fees

        vm.deal(address(this), 10 ether); // Allocating 10 ETH to the testing account for gas and fees
    }

    function testPlayGameAndWin() public {
        // Arrange
        uint256 requestId = rockPaperScissors.playGame{value: entryFees}(
            RockPaperScissors.Choice.ROCK
        );

        // Act
        uint256 mockRandomNumber = 2; // Should result in SCISSORS, player wins
        uint256[] memory randomWords = new uint256[](1);
        randomWords[0] = mockRandomNumber;

        vrfCoordinator.fulfillRandomWordsWithOverride(
            uint256(requestId),
            address(vrfWrapper),
            randomWords
        );

        // Assert
        (, , RockPaperScissors.Outcome outcome, ) = rockPaperScissors.statuses(
            requestId
        );

        assertEq(
            uint(outcome),
            uint(RockPaperScissors.Outcome.WIN),
            "Outcome should be WIN"
        );
        assertEq(
            rockPaperScissors.balances(address(this)),
            entryFees * 2,
            "Player should receive double the entry fee"
        );
    }

    function testPlayGameAndLose() public {
        // Arrange
        uint256 requestId = rockPaperScissors.playGame{value: entryFees}(
            RockPaperScissors.Choice.ROCK
        );

        // Act
        uint256 mockRandomNumber = 1; // Should result in PAPER, player loses
        uint256[] memory randomWords = new uint256[](1);
        randomWords[0] = mockRandomNumber;

        vrfCoordinator.fulfillRandomWordsWithOverride(
            uint256(requestId),
            address(vrfWrapper),
            randomWords
        );

        // Assert
        (, , RockPaperScissors.Outcome outcome, ) = rockPaperScissors.statuses(
            requestId
        );

        assertEq(
            uint(outcome),
            uint(RockPaperScissors.Outcome.LOSE),
            "Outcome should be LOSE"
        );
        assertEq(
            rockPaperScissors.balances(address(this)),
            0,
            "Player should not receive any ETH"
        );
    }

    function testPlayGameAndDraw() public {
        // Arrange
        uint256 requestId = rockPaperScissors.playGame{value: entryFees}(
            RockPaperScissors.Choice.ROCK
        );

        // Act
        uint256 mockRandomNumber = 0; // Should result in ROCK, player draws
        uint256[] memory randomWords = new uint256[](1);
        randomWords[0] = mockRandomNumber;

        vrfCoordinator.fulfillRandomWordsWithOverride(
            uint256(requestId),
            address(vrfWrapper),
            randomWords
        );

        // Assert
        (, , RockPaperScissors.Outcome outcome, ) = rockPaperScissors.statuses(
            requestId
        );

        assertEq(
            uint(outcome),
            uint(RockPaperScissors.Outcome.DRAW),
            "Outcome should be DRAW"
        );
        assertEq(
            rockPaperScissors.balances(address(this)),
            entryFees,
            "Player should get money back"
        );
    }

    function testWithdrawNoBalance() public {
        vm.prank(address(1));
        vm.expectRevert("Insufficient balance");
        rockPaperScissors.withdraw();
    }

    function testWithdraw() public {
        // Arrange
        deal(address(rockPaperScissors), 10 ether);
        startHoax(address(1), 2 ether);
        // Play game and win
        uint256 requestId = rockPaperScissors.playGame{value: entryFees}(
            RockPaperScissors.Choice.ROCK
        );
        uint256 mockRandomNumber = 2; // Should result in SCISSORS, player wins
        uint256[] memory randomWords = new uint256[](1);
        randomWords[0] = mockRandomNumber;
        vrfCoordinator.fulfillRandomWordsWithOverride(
            uint256(requestId),
            address(vrfWrapper),
            randomWords
        );
        uint256 balanceBefore = address(1).balance;

        // Act
        rockPaperScissors.withdraw();

        // Assert
        assertEq(
            rockPaperScissors.balances(address(this)),
            0,
            "Player should have withdrawn all the ETH"
        );
        assertEq(address(1).balance, balanceBefore + entryFees * 2);
    }
}
