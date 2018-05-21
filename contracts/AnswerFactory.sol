pragma solidity ^0.4.23;

import "./QuestionFactory.sol";

contract AnswerFactory is QuestionFactory {

    event NewAnswer(uint questionId, uint answerId, address answerer);

    struct Answer {
        address owner;
        uint upvotes;
    }

    mapping(uint => uint) public answerIdToQuestionId;

    Answer[] public answers;

    function createAnswer(uint _questionId) public payable questionOpen(_questionId) {
        require(msg.value >= questions[_questionId].answerFee);
        uint id = answers.push(Answer(msg.sender, 0)) - 1;
        emit NewAnswer(_questionId, id, msg.sender);
    }

}