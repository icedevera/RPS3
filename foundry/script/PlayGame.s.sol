// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {RockPaperScissors} from "../src/RockPaperScissors.sol";
import {Script, console} from "forge-std/Script.sol";

contract PlayGameScript is Script {
    RockPaperScissors public rockPaperScissors;

    function setUp() public {}

    function run() public {
        address rockPaperScissorsAddress = vm.envAddress(
            "LOCAL_DEV_ROCK_PAPER_SCISSORS_ADDRESS"
        );
        uint privateKey = vm.envUint("LOCAL_DEV_ANVIL_PRIVATE_KEY");
        uint choice = vm.envUint("LOCAL_DEV_CHOICE");

        vm.startBroadcast(privateKey);

        rockPaperScissors = RockPaperScissors(
            payable(rockPaperScissorsAddress)
        );

        uint requestId = rockPaperScissors.playGame{value: 0.001 ether}(
            RockPaperScissors.Choice(choice)
        );

        console.log(
            string.concat(
                "Play game complete with requestId: ",
                uint2str(requestId)
            )
        );

        vm.stopBroadcast();
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
}
