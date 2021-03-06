// Dapp University
pragma solidity ^0.5.1;

contract TrustPaymentContract {
    address payable public beneficiary;
    uint256 public releaseTime;
    address public familyLawyer;
    bool public lawyerApproval = false;

    constructor(address payable _beneficiary, address _familyLawyer, uint256 _releaseTime) public payable {
        require(_releaseTime > block.timestamp, "Release time has already passed");
        beneficiary = _beneficiary;
        familyLawyer = _familyLawyer;
        releaseTime = _releaseTime;
    }

    function withdraw() public {
        require(block.timestamp >= releaseTime, "Attempting to withdraw too early.");
        require(lawyerApproval, "Make sure the lawyer has approved the transaction");
        address(beneficiary).transfer(address(this).balance);
    }

    function lawyerApprove() public {
        require(msg.sender == familyLawyer, "Incorrect Address");
        lawyerApproval = true;
    }
}