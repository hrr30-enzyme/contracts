pragma solidity ^0.4.23;

contract Question {

    uint minBounty = .003 ether;
    uint duration = 1 days;
    uint endTime;
    uint bounty;
    address asker;

    constructor() public payable {
        require(msg.value >= minBounty);
        endTime = now + duration;
        bounty = msg.value;
    }
}

contract QuestionFactory {

    address owner;

    address[] public questions;

    function getQuestionsCount() public view returns (uint questionsCount) {
        return questions.length;
    }

    function newQuestion() public returns (address newContract) {
        Question q = new Question();
        questions.push(q);
        return q;
    }

    constructor() public payable {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}