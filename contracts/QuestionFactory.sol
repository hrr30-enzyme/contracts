pragma solidity ^0.4.23;

import "./QuestionInterface.sol";

contract QuestionFactory {

    address owner;
    uint minBounty;
    uint duration;
    uint answerFee;

    address[] public questions;

    function getQuestionsCount() public view returns (uint questionsCount) {
        return questions.length;
    }

    function newQuestion() public payable returns (address newContract) {
        require(msg.value > minBounty);
        
        Question q = (new QuestionInterface).value(msg.value)(minBounty, duration, msg.sender, answerFee);
        
        questions.push(q);
        
        return q;
    }

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}

