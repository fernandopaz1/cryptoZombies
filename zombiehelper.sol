pragma solidity ^0.4.19;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {

    // Este modificado añade el requerimiento de que el zombie tenga un nivel mayor
    // al que pasamos por parametro
    modifier aboveLevel(uint _level, uint _zombieId) {
        require(zombies[_zombieId].level >= _level);
        _;
    }

    // Ejemplo de modifiers por nivel
    function changeName(uint _zombieId, string _newName) external aboveLevel(2, _zombieId) {
        require(msg.sender == zombieToOwner[_zombieId]);
        zombies[_zombieId].name = _newName;
    }

    function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) {
        require(msg.sender == zombieToOwner[_zombieId]);
        zombies[_zombieId].dna = _newDna;
    }
}
