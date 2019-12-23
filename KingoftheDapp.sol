pragma solidity ^0.5.0;

// Contract from OpenZeppelin Package
import "@openzeppelin/contracts/math/SafeMath.sol";

contract KingDappContract {
    using SafeMath for uint;
    address payable public king;
    uint public kingRansom;
    mapping (address => uint256) public refunds;

    event Coronation(address indexed newKing, uint kingRansom);
    event Refund(address indexed to, uint refundAmount);

    constructor() public payable {
        king = msg.sender;
        kingRansom = msg.value;
    }


    function() external payable {
        revert("Please invoke a funtion when sending Eth to this address");
    }

    function becomeKing() public payable {
        require(msg.value >= (kingRansom.add(0.1 ether)), "Eth included was not enough");

        address payable oldKing = king;
        uint oldRansom = kingRansom;
        refunds[oldKing] = oldRansom;

        king = msg.sender;
        kingRansom = msg.value;
        emit Coronation(msg.sender, msg.value);
    }

    function withdrawRefund() external payable {
        require(refunds[msg.sender] > 0, "You do not have a balance to refund");
        uint256 refundAmount = refunds[msg.sender];
        refunds[msg.sender] = 0;
        msg.sender.transfer(refundAmount);
        emit Refund(msg.sender, refundAmount);
    }
}