pragma solidity ^0.4.23;

import "./UpVote.sol";


contract QuestionInterface is UpVote {

    constructor(uint _minBounty, uint _duration, address _asker, uint _answerFee) public payable {
        minBounty = _minBounty;
        duration = _duration;
        owner = msg.sender;
        endTime = now + duration;
        bounty = msg.value;
        asker = _asker;
        answerFee = _answerFee;
    }

    function donateToBounty() public payable {
        bounty += msg.value;
    }
}