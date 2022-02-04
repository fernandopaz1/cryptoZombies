pragma solidity ^0.4.19;

import "./zombiefeeding.sol";

contract ZombieHelper is ZombieFeeding {

    uint levelUpFee = 0.001 ether;

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

    function levelUp(uint _zombieId) external payable {
        require(msg.value == levelUpFee);
        zombies[_zombieId].level++;
    }

    // las funciones tipo view no cuestan gas, ya que la idea es que no se hagan
    // operaciones de escritura ni calculos en estas, serian solo de lectura lo 
    // cual no cuesta nada
    function getZombiesByOwner(address _owner) external view returns(uint[]) {
        // usar storage cuesta gas a diferencia de usar memory
        uint[] memory result = new uint[](ownerZombieCount[_owner]);
        uint counter = 0;
        for(uint i=0; i < zombies.length; i++ ){
            if(zombieToOwner[i] == _owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }

    // si vamos a recibir pagos queremos que owner pueda trasferir el balance total
    // a su cuenta
    function withdraw() external onlyOwner {
        owner.transfer(this.balance);
    }

    // no nos conviene dejar el fee como constante ya que 
    // los precios pueden cambiar.
    function setLevelUpFee(uint _fee) external onlyOwner {
        levelUpFee = _fee;
    }
}
