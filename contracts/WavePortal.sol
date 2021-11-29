// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;
//Ignore import error, may just be editor incompatibility, contract will still compile.
import "hardhat/console.sol";

contract WavePortal {

    struct WaveStorage {
        address addr;
        uint256 totalWaves;
    }
    uint256 public waverCounter;
    mapping(uint => WaveStorage) public waveStorage;
    constructor() {
        console.log("~~~Smart Contract to collect your waves!~~~");
    }
    function addWaver (address _addr) public{
        waverCounter += 1;
        waveStorage[waverCounter] = WaveStorage(_addr,1);
        console.log("%s has waved! and has been added to the mapping.", msg.sender);
    }
    function incrementWave (uint256 i) public{
        console.log("waves incremented");
      waveStorage[i].totalWaves +=1;
    }

     function findWaverInMap () public view returns(uint8 i){
      for(uint8 i=1; i<= waverCounter; i++){
        if(msg.sender == waveStorage[i].addr){
            return i;
        }
        }
    }
    function waverExists () public view returns(bool){

        for(uint8 i=1; i<= waverCounter; i++){
        if(msg.sender == waveStorage[i].addr){
            return true;
        }
        }
        return false;

    }

    function wave() public {
        if(waverExists()){
            incrementWave(findWaverInMap());
       
        }else{
           addWaver(msg.sender); 
        }
        
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total wavers!", waverCounter );
         for(uint8 i=1; i<= waverCounter; i++){
        console.log("address~: %s  WAVES:%d", waveStorage[i].addr,waveStorage[i].totalWaves);
    }
        
        return waveStorage[0].totalWaves;
    }
}
