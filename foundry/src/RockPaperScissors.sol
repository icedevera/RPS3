// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {VRFV2WrapperConsumerBase} from "@chainlink/contracts/src/v0.8/VRFV2WrapperConsumerBase.sol";

/**
 * @title Rock Paper Scissors game contract
 * @author Ice de Vera
 * @notice This contract is for a Rock Paper Scissors game
 * @dev Implements Chainlink VRFv2
 */
contract RockPaperScissors is VRFV2WrapperConsumerBase {
    event PlayGameRequest(uint256 indexed requestId, address indexed player);
    event PlayGameResult(
        uint256 indexed requestId,
        address indexed player,
        Outcome outcome
    );
    event Withdraw(address indexed player, uint256 amount);

    struct GameStatus {
        uint256 fees;
        address player;
        Outcome outcome;
        Choice playerChoice;
    }

    enum Choice {
        ROCK,
        PAPER,
        SCISSORS
    }

    enum Outcome {
        NONE,
        WIN,
        LOSE,
        DRAW
    }

    mapping(uint256 => GameStatus) public statuses;
    mapping(address => uint256) public balances;
    mapping(address => uint256) public lastRequestId;
    mapping(address => GameStatus[]) internal gameHistory;

    uint256 internal totalBalanceAmount = 0;

    uint128 constant entryFees = 0.001 ether;
    uint32 constant callbackGasLimit = 300_000;
    uint16 constant requestConfirmations = 3;
    uint32 constant numWords = 1;

    constructor(
        address linkAddress,
        address vrfWrapperAddress
    ) payable VRFV2WrapperConsumerBase(linkAddress, vrfWrapperAddress) {}

    function playGame(Choice choice) external payable returns (uint256) {
        require(msg.value == entryFees, "Insufficient entry fees");

        // Assume potential win to totalBalanceAmount to prevent contract from running out of balance
        totalBalanceAmount += entryFees * 2;
        require(
            address(this).balance >= totalBalanceAmount,
            "Insufficient contract balance"
        );

        uint256 requestId = requestRandomness(
            callbackGasLimit,
            requestConfirmations,
            numWords
        );

        lastRequestId[msg.sender] = requestId;

        statuses[requestId] = GameStatus({
            fees: VRF_V2_WRAPPER.calculateRequestPrice(callbackGasLimit),
            player: msg.sender,
            outcome: Outcome.NONE,
            playerChoice: choice
        });

        emit PlayGameRequest(requestId, msg.sender);

        return requestId;
    }

    function fulfillRandomWords(
        uint256 requestId,
        uint256[] memory randomWords
    ) internal override {
        require(statuses[requestId].fees > 0, "Request not found");

        Choice computerChoice = Choice(randomWords[0] % 3);

        if (statuses[requestId].playerChoice == computerChoice) {
            // Push. Refund entry fees.
            statuses[requestId].outcome = Outcome.DRAW;
            balances[statuses[requestId].player] += entryFees;
            totalBalanceAmount -= entryFees; // Subtract entry fee as totalBalanceAmount was added in playGame fn with a potential win
        } else if (
            (statuses[requestId].playerChoice == Choice.ROCK &&
                computerChoice == Choice.SCISSORS) ||
            (statuses[requestId].playerChoice == Choice.PAPER &&
                computerChoice == Choice.ROCK) ||
            (statuses[requestId].playerChoice == Choice.SCISSORS &&
                computerChoice == Choice.PAPER)
        ) {
            // Win. Get double entry fees.
            statuses[requestId].outcome = Outcome.WIN;
            balances[statuses[requestId].player] += entryFees * 2;
        } else {
            // Lose. Keep entry fees.
            statuses[requestId].outcome = Outcome.LOSE;
            totalBalanceAmount -= entryFees * 2; // Subtract entry fee as totalBalanceAmount was added in playGame fn with a potential win
        }

        gameHistory[statuses[requestId].player].push(statuses[requestId]);

        emit PlayGameResult(
            requestId,
            statuses[requestId].player,
            statuses[requestId].outcome
        );
    }

    function withdraw() external {
        require(balances[msg.sender] > 0, "Insufficient balance");
        uint256 amount = balances[msg.sender];
        balances[msg.sender] = 0;
        (bool sent, ) = payable(msg.sender).call{value: amount}("");
        require(sent, "Failed to send Ether");

        totalBalanceAmount -= amount;

        emit Withdraw(msg.sender, amount);
    }

    function getGameHistory() external view returns (GameStatus[] memory) {
        return gameHistory[msg.sender];
    }

    receive() external payable {}
}
