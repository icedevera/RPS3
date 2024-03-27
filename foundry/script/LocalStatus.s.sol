// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {RockPaperScissors} from "../src/RockPaperScissors.sol";
import {Script, console} from "forge-std/Script.sol";

contract LocalStatusScript is Script {
    RockPaperScissors public rockPaperScissors;

    function setUp() public {}

    function run() public {
        address rockPaperScissorsAddress = vm.envAddress(
            "LOCAL_DEV_ROCK_PAPER_SCISSORS_ADDRESS"
        );
        uint requestId = vm.envUint("LOCAL_DEV_REQUEST_ID");
        uint privateKey = vm.envUint("LOCAL_DEV_ANVIL_PRIVATE_KEY");

        vm.startBroadcast(privateKey);

        rockPaperScissors = RockPaperScissors(
            payable(rockPaperScissorsAddress)
        );

        (, , RockPaperScissors.Outcome outcome, ) = rockPaperScissors.statuses(
            requestId
        );

        console.log(
            string.concat(
                "RequestId outcome for requestId ",
                uint2str(requestId),
                ": ",
                outcome2str(outcome)
            )
        );

        vm.stopBroadcast();
    }

    function outcome2str(
        RockPaperScissors.Outcome outcome
    ) internal pure returns (string memory _outcome) {
        if (outcome == RockPaperScissors.Outcome.NONE) {
            return "NONE";
        } else if (outcome == RockPaperScissors.Outcome.WIN) {
            return "WIN";
        } else if (outcome == RockPaperScissors.Outcome.LOSE) {
            return "LOSE";
        } else if (outcome == RockPaperScissors.Outcome.DRAW) {
            return "DRAW";
        }
    }

    function uint2str(
        uint _i
    ) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k - 1;
            uint8 temp = (48 + uint8(_i - (_i / 10) * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }

    function bool2str(bool input) internal pure returns (string memory) {
        if (input) {
            return "true";
        } else {
            return "false";
        }
    }
}
