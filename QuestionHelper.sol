pragma solidity ^0.4.23;

import "./AnswerFactory.sol";

contract QuestionHelper is AnswerFactory {

    event NewAnswer(uint questionId, uint answerId, address answerer, uint stake);

    uint duration = 1 days;

    struct Answer {
        uint questionId;
        uint stake;
    }

    Answer[] public answers;

    mapping (uint => address) public questionToOwner;
    
    function _createQuestion(uint _questionId) public payable {
        uint id = answers.push(Answer(_questionId, msg.value)) - 1;
        questionToOwner[id] = msg.sender;
        NewAnswer(_questionId, id, msg.sender, msg.value);
    }
}