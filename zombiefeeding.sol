pragma solidity ^0.4.19;

import "./zombiefactory.sol";

// interfaz de cryptoKitties
contract KittyInterface {
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}

contract ZombieFeeding is ZombieFactory {

    address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d; // CryptoKitties address
    KittyInterface kittyContract = KittyInterface(ckAddress);       // inicializamos la interfaz
    
    // un zombie se alimenta de un target combinando ambos dna
    function feedAndMultiply(uint _zombieId, uint _targetDna, string _species) public {
        require(msg.sender == zombieToOwner[_zombieId]); // Cheqeamos que somos el dueño del Zombie
        Zombie storage myZombie = zombies[_zombieId]:   // Obtenemos el zombie a partit de su Id
        _targetDna = _targetDna % dnaModulus;
        uint newDna = (myZombie.dna + _targetDna) / 2;
        if(keccak256(_species) == keccak256("kitty")){
            newDna = newDna - newDna % 100 + 99;        // si es kitty le ponemos 99 en los ultimos digitos 
        }
        _createZombie("NoName", newDna);
    }
    
    function feedOnKitty(uint _zombieId, uint _kittyId) public {
        uint kittyDna;
        (,,,,,,,,,kittyDna) = getKitty(_kittyId); // devuelve 10 valores solo necesitamos el ultimo
        feedAndMultiply(_zombieId, kittyDna, "kitty"); // una vez come gatos _species = kitty
    }
}
