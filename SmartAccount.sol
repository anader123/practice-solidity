pragma solidity ^0.5.0;

contract SmartAccount {
    address payable owner;
    mapping (address => bool) public accounts;

    event AccountAdded(address indexed account);
    event AccountRemoved(address indexed account);

    constructor() public {
        owner = msg.sender;
        accounts[msg.sender] = true;
        emit AccountAdded(msg.sender);
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function addAccount(address _newAccount) public onlyOwner {
        accounts[_newAccount] = true;
        emit AccountAdded(_newAccount);
    }

    function removeAccount(address _toRemove) public onlyOwner {
        accounts[_toRemove] = false;
        emit AccountRemoved(_toRemove);
    }

    // Forward calls and funds to a third party;
    function forward(address _to, uint _value, bytes memory _data) public returns (bytes memory) {
        require(accounts[msg.sender]);
        (bool success, bytes memory returnData) = _to.call.value(_value)(_data);
        require(success);
        return returnData;
    }

    // Fallback function for ether deposits
    function() external payable {}
}