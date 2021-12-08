// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;
//Ignore import error, may just be editor incompatibility, contract will still compile.
//Alternative import for hardhat is ../node_modules/hardhat/console.sol;
import "hardhat/console.sol";

contract AdoptADino {
    uint256 totalAdoptions;
    uint256 private seed;
    event NewDino(address indexed from, uint256 timestamp, uint256 id);
    struct Dino {
        address ownerOf;
        uint256 dinoID;
        uint256 timeAdopted;
    }

    Dino[] dinos;
    mapping(address => uint256) public lastAdoptedAt;
    constructor() payable {
        console.log("Time to adopt some Dinos!");

        seed = (block.timestamp + block.difficulty) % 100;
    }

    // function random() internal view returns (uint256) {
    //     uint256 randomnumber = uint256(
    //         keccak256(abi.encodePacked(block.timestamp, msg.sender))
    //     ) % 7;
    //     randomnumber = randomnumber;

    //     console.log("Random number is: %d", randomnumber);
    //     return randomnumber;
    // }

    function adopt() public {

         /*
         * We need to make sure the current timestamp is at least 15-minutes bigger than the last timestamp we stored
         */
        require(
            lastAdoptedAt[msg.sender] + 20 seconds < block.timestamp,
            "Wait 20 seconds before trying to adopt again."
        );

        /*
         * Update the current timestamp we have for the user
         */
        lastAdoptedAt[msg.sender] = block.timestamp;
        totalAdoptions += 1;
        uint256 id = (block.difficulty + block.timestamp + seed) % 100 % 12;
        console.log("%s adopted a dino with an ID of %d", msg.sender, id);

        /*
         * This is where I actually store the wave data in the array.
         */
        dinos.push(Dino(msg.sender, id, block.timestamp));
        /*
         * Generate a new seed for the next user that sends a wave
         */
        seed = (block.difficulty + block.timestamp + seed) % 100;

        console.log("Random # generated: %d", seed);
        if (seed <= 50) {
            console.log("%s won!", msg.sender);

            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }
        emit NewDino(msg.sender, block.timestamp, id);
    }

    function getAllDinos() public view returns (Dino[] memory) {
        return dinos;
    }

    function getTotalDinos() public view returns (uint256) {
        // Optional: Add this line if you want to see the contract print the value!
        // We'll also print it over in run.js as well.
        console.log("We have %d total adoptions!", totalAdoptions);
        return totalAdoptions;
    }
}
