// Consensys online course
pragma solidity ^0.5.0;

contract MultiSignatureWallet {

    address[] public owners;
    uint public required;
    mapping (address => bool) public isOwner;

    uint public transactionCount;
    mapping (uint => Transaction) public transactions;

    mapping (uint => mapping (address => bool)) public confirmations;

    struct Transaction {
      bool executed;
      address destination;
      uint value;
      bytes data;
    }

    event Deposit(address indexed sender, uint value);
    event Submission(uint indexed transactionId);
    event Confirmation(address indexed sender, uint indexed transactionId);
    event Execution(uint indexed transacitonId);
    event ExecutionFailure(uint indexed transactionId);

    modifier validRequirement(uint ownerCount, uint _required) {
        if(_required > ownerCount || _required == 0 || ownerCount == 0)
            revert();
        _;
    }

    function()
    	external
        payable
    {
        if (msg.value > 0) {
            emit Deposit(msg.sender, msg.value);
	}
    }


    constructor(address[] memory _owners, uint _required) public validRequirement(_owners.length, _required)
    {
        for(uint i=0; i<_owners.length; i++) {
            isOwner[_owners[i]] = true;
        }
        owners = _owners;
        required = _required;
    }

    function submitTransaction(address destination, uint value, bytes memory data)
    public
    returns (uint transactionId)
    {
        require(isOwner[msg.sender]);
        transactionId = addTransaction(destination, value, data);
        confirmTransaction(transactionId);
    }


    function confirmTransaction(uint transactionId)
    public
    {
        require(isOwner[msg.sender]);
        require(transactions[transactionId].destination != address(0));
        require(confirmations[transactionId][msg.sender] == false);
        confirmations[transactionId][msg.sender] = true;
        emit Confirmation(msg.sender, transactionId);
        executeTransaction(transactionId);
    }

    function executeTransaction(uint transactionId)
    public
    {
        require(transactions[transactionId].executed == false);
        if(isConfirmed(transactionId)) {
            Transaction storage t = transactions[transactionId];
            t.executed = true;
            (bool success, bytes memory returnData) = t.destination.call.value(t.value)(t.data);
            if(success)
                emit Execution(transactionId);
            else {
                emit ExecutionFailure(transactionId);
                t.executed = false;
            }
        }
    }


    function isConfirmed(uint transactionId)
    internal
    view
    returns (bool)
    {
        uint count = 0;
        for (uint i = 0; i<owners.length; i++) {
            if(confirmations[transactionId][owners[i]])
                count += 1;
            if(count == required)
                return true;
        }
    }

    function addTransaction(address _destination, uint _value, bytes memory _data)
    internal
    returns
    (uint transactionId)
    {
        transactionId = transactionCount;
        transactions[transactionId] = Transaction({
            destination: _destination,
            value: _value,
            data: _data,
            executed: false
        });
        ++transactionCount;
        emit Submission(transactionId);
    }
}