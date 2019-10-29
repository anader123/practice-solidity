pragma solidity 0.5.11;

contract KilloftheHillContract {
    address payable public king;
    uint public kingPrice;

    constructor() public {
        king = msg.sender;
    }

    // Fallback function
    function() external payable {
        becomeKing();
    }

    function becomeKing() public payable {
        require(msg.value > kingPrice, "The value deposited must be greater than the last king");
        kingPrice = msg.value;
        // Transfers balance to the old king.
        king.transfer(msg.value);
        king = msg.sender;
    }
}