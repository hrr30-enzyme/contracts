pragma solidity ^0.4.23;

import "./Question.sol";

contract AnswerFactory is Question {

    uint answerFee = .001 ether;

    event NewAnswer(uint answerId, address answerer);

    struct Answer {
        uint upvotes;
    }

    Answer[] public answers;

    mapping (uint => address) public answerToOwner;

    function setAnswerFee(uint _fee) external onlyOwner {
        answerFee = _fee;
    }

    function _createAnswer() internal {
        require(msg.value >= answerFee);
        uint id = answers.push(Answer(0)) - 1;
        answerToOwner[id] = msg.sender;
        emit NewAnswer(id, msg.sender);
    }

}