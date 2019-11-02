// Personal Idea
// Location: https://ropsten.etherscan.io/address/0x0b889f8ba286faf11951caea2521d03d10a39b01#code
pragma solidity 0.5.11;

contract KingoftheHillContract {
    address payable public king;
    uint public kingPrice;

    event Coronation(address indexed _newKing, uint indexed _newKingPrice);

    constructor() public payable {
        king = msg.sender;
        kingPrice = msg.value;
    }

    // Fallback function
    function() external payable {
        revert();
    }

    function becomeKing() public payable {
        require(msg.value > kingPrice, "The value deposited must be greater than the last king");
        kingPrice = msg.value;
        // Transfers balance to the old king.
        king.transfer(msg.value);
        king = msg.sender;
        emit Coronation(king, kingPrice);
    }
}