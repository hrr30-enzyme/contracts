pragma solidity ^0.4.23;

contract QuestionFactory {

    address owner;
    uint minBounty;
    uint duration;
    uint answerFee;

    event NewQuestion(
        uint questionId,
        uint endTime,
        uint bounty,
        address asker,
        uint answerFee
    );

    struct Question {
        uint endTime;
        uint bounty;
        address asker;
        uint answerFee;
        bool payedOut;
    }

    Question[] public questions;

    function getQuestionsCount() public view returns (uint) {
        return questions.length;
    }
    
    function getMinBounty() public view returns (uint) {
        return minBounty;
    }
    
    function setMinBounty(uint _minBounty) public onlyOwner{
        minBounty = _minBounty;
    }
    
    function getDuration() public view returns (uint) {
        return duration;
    }
    
    function setDuration(uint _duration) public onlyOwner {
        duration = _duration;
    }
    
    function getAnswerFee() public view returns (uint) {
        return answerFee;
    }
    
    function setAnswerFee(uint _answerFee) public onlyOwner {
        answerFee = _answerFee;
    }

    function newQuestion() public payable {
        require(msg.value > minBounty);
        
        uint _endTime = now + duration;

        uint id = questions.push(Question(
            _endTime,
            msg.value,
            msg.sender,
            answerFee,
            false
        )) - 1;

        emit NewQuestion(
            id,
            _endTime,
            msg.value,
            msg.sender,
            answerFee
        );
    }

    constructor() public {
        owner = msg.sender;
    }

    modifier questionOpen(uint _questionId) {
        require(now <= questions[_questionId].endTime);
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}

