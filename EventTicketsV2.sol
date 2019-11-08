// Consensys online course
pragma solidity ^0.5.0;

contract EventTicketsV2 {

    uint public  PRICE_TICKET = 100 wei;
    address payable public owner;

    uint public eventCount;

    struct Event {
        string description;
        string website;
        uint totalTickets;
        uint sales;
        mapping (address => uint) buyers;
        bool isOpen;
    }

    mapping (uint => Event) events;

    event LogEventAdded(string desc, string url, uint ticketsAvailable, uint eventId);
    event LogBuyTickets(address buyer, uint eventId, uint numTickets);
    event LogGetRefund(address accountRefunded, uint eventId, uint numTickets);
    event LogEndSale(address owner, uint balance, uint eventId);

    modifier isOwner {require(msg.sender == owner, "You must be the owner of this contract to call this function"); _;}

    constructor() public {
        owner = msg.sender;
    }

    function addEvent(string memory _description, string memory _URL, uint _totalTickets)
        public
        isOwner
        returns(uint)
    {
        uint eventId = eventCount;
        events[eventId] = Event({description: _description, website: _URL, totalTickets: _totalTickets, isOpen: true, sales:0});
        eventCount++;
        emit LogEventAdded(_description, _URL, _totalTickets, eventId);
        return eventId;
    }

    function readEvent(uint _eventId)
        public
        view
        returns(string memory description, string memory website, uint totalTickets, uint sales, bool isOpen)
    {
        description = events[_eventId].description;
        website = events[_eventId].website;
        totalTickets = events[_eventId].totalTickets;
        sales = events[_eventId].sales;
        isOpen = events[_eventId].isOpen;
        return(description, website, totalTickets, sales, isOpen);
    }

    function buyTickets(uint _eventId, uint _ticketAmount) public payable {
        require(events[_eventId].isOpen, "Event is no longer selling tickets");
        require(msg.value >= PRICE_TICKET * _ticketAmount, "You didn't pay enough to purchase that amount of tickets");
        require(events[_eventId].totalTickets - events[_eventId].sales >= _ticketAmount, "There aren't enought tickets left");
        events[_eventId].buyers[msg.sender] += _ticketAmount;
        events[_eventId].sales += _ticketAmount;
        if (msg.value > (_ticketAmount * PRICE_TICKET)) {
            msg.sender.transfer(msg.value - (_ticketAmount * PRICE_TICKET));
        }
        emit LogBuyTickets(msg.sender, _eventId, _ticketAmount);
    }

    function getRefund(uint _eventId) public {
        require(events[_eventId].buyers[msg.sender] > 0, "You don't have any tickets to refund from this address");
        uint ticketAmount = events[_eventId].buyers[msg.sender];
        uint refundAmount = events[_eventId].buyers[msg.sender]*PRICE_TICKET;
        events[_eventId].sales -= ticketAmount;
        events[_eventId].buyers[msg.sender] = 0;
        msg.sender.transfer(refundAmount);
        emit LogGetRefund(msg.sender, _eventId, ticketAmount);
    }

    function getBuyerNumberTickets(uint _eventId) public view returns(uint) {
        return events[_eventId].buyers[msg.sender];
    }

    function endSale(uint _eventId) public isOwner {
        events[_eventId].isOpen = false;
        uint eventBalance = events[_eventId].sales * PRICE_TICKET;
        owner.transfer(eventBalance);
        emit LogEndSale(owner, eventBalance, _eventId);
    }
}
