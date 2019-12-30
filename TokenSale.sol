pragma solidity ^0.5.0;

interface Token {
    function transfer(address x, uint y) external returns(bool);
    function balanceOf(address a) external view returns(uint);
}

contract TokenSale {
    address payable wallet;
    Token token;

    event TokenPurchase(address buyer, uint256 amount);

    constructor(address payable _wallet, Token _tokenAddress) public {
        wallet = _wallet;
        token = Token(_tokenAddress);
    }

    function buyToken() public payable {
        // one token per ether, assuming 18 decimal places for the token
        require(token.balanceOf(address(this)) > msg.value);
        token.transfer(msg.sender, msg.value);
        emit TokenPurchase(msg.sender, msg.value);
    }

    function withdrawEther() public payable {
        require(msg.sender == wallet);
        wallet.transfer(address(this).balance);
    }

    function() external payable {
        revert();
    }

}