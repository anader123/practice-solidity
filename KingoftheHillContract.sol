pragma solidity ^0.5.0;

// Contract from OpenZeppelin Package
import "@openzeppelin/contracts/math/SafeMath.sol";

contract KingDappContract {
    using SafeMath for uint;
    address payable public King;
    uint public kingRansom;

    constructor() public payable {
        King = msg.sender;
        kingRansom = msg.value;
    }

    event Coronation(address indexed _newKing, uint _kingRansom);

    function() external payable {
        revert("Please invoke a funtion when sending Eth to this address");
    }

    function becomeKing() public payable {
        require(msg.value >= (kingRansom.add(0.1 ether)), "Eth included was not enough");
        address payable oldKing = King;
        uint oldRansom = kingRansom;
        King = msg.sender;
        kingRansom = msg.value;
        oldKing.transfer(oldRansom);
        emit Coronation(msg.sender, msg.value);
    }
}