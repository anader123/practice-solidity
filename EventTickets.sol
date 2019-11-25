// Consensys online course
pragma solidity ^0.5.0;

// Contract from OpenZeppelin Package
import "@openzeppelin/contracts/math/SafeMath.sol";

contract EventTickets {
    using SafeMath for uint;
    address payable public owner;
    uint public TICKET_PRICE = 100 wei;

    struct Event {
        string description;
        string website;
        uint totalTickets;
        uint sales;
        mapping (address => uint) buyers;
        bool isOpen;
    }
    Event public myEvent;

    event LogBuyTickets(address indexed _buyer, uint indexed _ticketAmount);
    event LogGetRefund(address indexed _refundAddress, uint indexed _ticketAmount);
    event LogEndSale(address indexed _owner, uint indexed _balance);

    modifier isOwner {require(msg.sender == owner, "You are not the current owner of this contract"); _;}

    constructor(string memory _description, string memory _URL, uint _totalTickets) public {
        owner = msg.sender;
        myEvent = Event({description: _description, website: _URL, totalTickets: _totalTickets, isOpen: true, sales: 0});
    }

    function readEvent()
        public
        view
        returns(string memory description, string memory website, uint totalTickets, uint sales, bool isOpen)
    {
        description = myEvent.description;
        website = myEvent.website;
        totalTickets = myEvent.totalTickets;
        sales = myEvent.sales;
        isOpen = myEvent.isOpen;

        return(description, website, totalTickets, sales, isOpen);
    }

    function getBuyerTicketCount(address _buyer) public view returns(uint) {
        return myEvent.buyers[_buyer];
    }

    function buyTickets(uint _ticketAmount) public payable {
        require(myEvent.isOpen, "Purchasing has closed");
        require(msg.value >= _ticketAmount.mul(TICKET_PRICE), "Didn't include enough ETH for your purchase");
        require(myEvent.totalTickets.sub(myEvent.sales) >= _ticketAmount, "There aren't enough remaining tickets to purchase");

        myEvent.buyers[msg.sender] = myEvent.buyers[msg.sender].add(_ticketAmount);
        myEvent.sales = myEvent.sales.add(_ticketAmount);
        if (msg.value > (_ticketAmount.mul(TICKET_PRICE))) {
            msg.sender.transfer(msg.value.sub((_ticketAmount.mul(TICKET_PRICE))));
        }
        emit LogBuyTickets(msg.sender, _ticketAmount);
    }

    function getRefund() public payable {
        require(myEvent.buyers[msg.sender] > 0, "You currently don't any tickets");
        uint ticketAmount = myEvent.buyers[msg.sender];
        uint refundAmount = myEvent.buyers[msg.sender].mul(TICKET_PRICE);
        myEvent.sales = myEvent.sales.sub(ticketAmount);
        myEvent.buyers[msg.sender] = 0;
        msg.sender.transfer(refundAmount);
        emit LogGetRefund(msg.sender, ticketAmount);
    }

    function endSale() public isOwner {
        myEvent.isOpen = false;
        owner.transfer(address(this).balance);
        emit LogEndSale(owner, address(this).balance);
    }
}
