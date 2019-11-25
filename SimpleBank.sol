// Consensys online course
pragma solidity ^0.5.0;

// Contract from OpenZeppelin Package
import "@openzeppelin/contracts/math/SafeMath.sol";

contract SimpleBank {
    using SafeMath for uint;
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
        require(enrolled[msg.sender] == false, "This address is already enrolled");
        enrolled[msg.sender] = true;
        emit LogEnrolled(msg.sender);
        return enrolled[msg.sender];
    }

    function deposit() public payable returns (uint) {
        require(enrolled[msg.sender], "This address is currently not enrolled");
        uint newBalance = balances[msg.sender].add(msg.value);
        balances[msg.sender] = newBalance;
        emit LogDepositMade(msg.sender, msg.value);
        return newBalance;
    }

    function withdraw(uint _withdrawAmount) public returns (uint) {
        require(_withdrawAmount <= balances[msg.sender], "Withdraw amount is greater than the balance");
        uint newBalance = balances[msg.sender].sub(_withdrawAmount);
        balances[msg.sender] = newBalance;
        msg.sender.transfer(_withdrawAmount);
        emit LogWithdrawal(msg.sender, _withdrawAmount, newBalance);
        return newBalance;
    }

}