pragma solidity ^0.4.23;

import "./QuestionFactory.sol";

contract AnswerFactory is QuestionFactory {

    uint answerFee = .001 ether;

    event NewAnswer(uint questionId, uint answerId, address answerer);

    struct Answer {
        uint questionId;
        uint upvotes;
    }

    Answer[] public answers;

    mapping (uint => address) public answerToOwner;

    function setAnswerFee(uint _fee) external onlyOwner {
        answerFee = _fee;
    }

    function _createQuestion(uint _questionId) public payable {
        require(msg.value >= answerFee);
        uint id = answers.push(Answer(_questionId, 0)) - 1;
        answerToOwner[id] = msg.sender;
        emit NewAnswer(_questionId, id, msg.sender);
    }

}