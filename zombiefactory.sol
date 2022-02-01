pragma solidity ^0.4.19;

contract ZombieFactory {

    event NewZombie(uint zombieId, string name, uint dna);

    // Todos los zombies estan codificados en 16 digitos
    // hay 10^16 zombies diferentes
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;

    //crea una zombie y lo agrega al array de zombies
    // via mapping lo asigna a un usuario y aumenta su cantidad de zombies
    // triggerea el evento NewZombie
    // con internal permitimos que sea usada por contratos que heredan de este
    function _createZombie(string _name, uint _dna) internal {
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        // Este evento comunica a la interfaz de usuario que
        // algo paso en la cadena de bloques
        NewZombie(id, _name, _dna);
    }

    // genera una dna random y lo limita a 16 digitos (dnaModulus)
    function _generateRandomDna(string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));
        return rand % dnaModulus;
    }


    function createRandomZombie(string _name) public {
        require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

}
