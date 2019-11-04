// Consensys online course
pragma solidity ^0.5.0;

contract SimpleBank {
    mapping (address => uint) internal balances;
    mapping (address => bool) public enrolled;
    address public owner;
    
    event LogEnrolled(address indexed accountAddress);
    event LogDepositMade(address indexed accountAddress, uint indexed amount);
    event LogWithdrawal(address indexed accountAddress, uint indexed withdrawAmount, uint indexed newBalance);

    constructor() public {
        owner = msg.sender;
    }

    function() external payable {
        revert();
    }

    function getBalance() public view returns (uint) {
        return balances[msg.sender];
    }

    function enroll() public returns (bool){
        require(enrolled[msg.sender] == false);
        enrolled[msg.sender] = true;
        emit LogEnrolled(msg.sender);
        return enrolled[msg.sender];
    }

    function deposit() public payable returns (uint) {
        require(enrolled[msg.sender]);
        uint newBalance = balances[msg.sender] + msg.value;
        balances[msg.sender] = newBalance;
        emit LogDepositMade(msg.sender, msg.value);
        return newBalance;
    }

    function withdraw(uint withdrawAmount) public returns (uint) {
        require(withdrawAmount <= balances[msg.sender]);
        uint newBalance = balances[msg.sender] - withdrawAmount;
        balances[msg.sender] = newBalance;
        msg.sender.transfer(withdrawAmount);
        emit LogWithdrawal(msg.sender, withdrawAmount, newBalance);
        return newBalance;
    }

}