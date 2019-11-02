// MakerDAO Dev Guide https://github.com/makerdao/developerguides
pragma solidity ^0.5.9;

interface DaiToken {
    function transfer(address dst, uint wad) external returns(bool);
    function balanceOf(address guy) external view returns(uint);
}

contract owned {
    DaiToken daitoken;
    address owner;

    constructor() public {
        owner = msg.sender;
        daitoken = DaiToken(0xC4375B7De8af5a38a93548eb8453a498222C4fF2);
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only the contract owner can call this function.");
        _;
    }
}

contract mortal is owned {
    function destroy() public onlyOwner {
        daitoken.transfer(owner, daitoken.balanceOf(address(this)));
        selfdestruct(msg.sender);
    }
}

contract DaiFaucet is mortal {
    event Withdrawal(address indexed to, uint amount);
    event Deposit(address indexed from, uint amount);

    function withdraw(uint _withdraw_amount) public {
        require(_withdraw_amount <= 0.1 ether, "Withdraw amount can't be larger than 0.1 Dai.");
        require(daitoken.balanceOf(address(this)) >= _withdraw_amount, "Insufficient balance in faucet.");
        // Send Dai the account that called the function.
        daitoken.transfer(msg.sender, _withdraw_amount);
        emit Withdrawal(msg.sender, _withdraw_amount);
    }

    // Fallback function
    function() external payable {
        emit Deposit(msg.sender, msg.value);
    }
}