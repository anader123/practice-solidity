// Dapp University
pragma solidity ^0.5.0;

import "@openzeppelin/contracts/math/SafeMath.sol";

contract Escrow {
    using SafeMath for uint;
    address public agent;
    mapping(address => uint256) public deposits;

    modifier onlyAgent() {
        require(msg.sender == agent);
        _;
    }

    constructor() public {
        agent = msg.sender;
    }

    function deposit(address _payee) public payable {
        uint256 amount = msg.value;
        deposits[_payee] = deposits[_payee].add(amount);
    }

    function withdraw(address payable _payee) public payable onlyAgent {
        uint256 payment = deposits[_payee];
        deposits[_payee] = 0;
        _payee.transfer(payment);
    }
}