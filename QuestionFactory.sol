pragma solidity ^0.4.23;

import "./Ownable.sol";

contract QuestionFactory is Ownable {

    event NewQuestion(uint questionId, address asker, uint bounty);

    uint duration = 1 days;

    struct Question {
        uint bounty;
        uint32 endTime;
    }

    Question[] public questions;

    mapping (uint => address) public questionToOwner;
    
    function _createQuestion() public payable {
        uint id = questions.push(Question(msg.value, uint32(now + duration))) - 1;
        questionToOwner[id] = msg.sender;
        NewQuestion(id, msg.sender, msg.value);
    }
}