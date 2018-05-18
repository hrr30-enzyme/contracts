pragma solidity ^0.4.23;

import "./QuestionFactory.sol";

contract AnswerFactory is QuestionFactory {

    event NewAnswer(uint questionId, uint answerId, address answerer, uint stake);

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