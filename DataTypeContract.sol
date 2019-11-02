// Dapp University
pragma solidity ^0.5.1;

contract PrimativeDataTypeContract {
    string public valueString = "This is the value";
    bool public constant valueBool = true;
    uint public valueUint = 1;

    function setString(string memory _valueString) public {
        valueString = _valueString;
    }

    // Constructor is not required to initialize the state of the valueString varible.
    // constructor() public {
    //     value = "This is the value";
    // }

    enum Race { Ready, Set, Go }
    Race public race;

    constructor() public {
        race = Race.Ready;
    }

    function getSet() public {
        race = Race.Set;
    }

    function startRace() public {
        race = Race.Go;
    }

    function hasRaceStarted() public view returns(bool){
        return race == Race.Go;
    }
}

contract EnumContract {
    enum Race { Ready, Set, Go }
    Race public race;

    constructor() public {
        race = Race.Ready;
    }

    function getSet() public {
        race = Race.Set;
    }

    function startRace() public {
        race = Race.Go;
    }

    function hasRaceStarted() public view returns(bool){
        return race == Race.Go;
    }
}

contract StructContract {
    Car[] public cars;
    // Can also use a mapping
    // mapping(uint => Car) public people;
    uint256 public carCount = 0;

    struct Car {
        // uint _id;
        string _make;
        string _model;
        string _color;
    }

    function addCar(string memory _make, string memory _model, string memory _color) public {
        carCount ++;
        cars.push(Car(_make, _model, _color));
    }
}


