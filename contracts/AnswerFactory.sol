pragma solidity ^0.4.23;

import "./Question.sol";

contract AnswerFactory is Question {

    uint answerFee;

    event NewAnswer(uint answerId, address answerer);

    struct Answer {
        address owner;
        uint16 upvotes;
    }

    Answer[] public answers;

    function createAnswer() public payable {
        require(msg.value >= answerFee);
        uint id = answers.push(Answer(msg.sender, 0)) - 1;
        emit NewAnswer(id, msg.sender);
    }

}