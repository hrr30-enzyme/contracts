pragma solidity ^0.4.23;

import "./QuestionFactory.sol";

/*
 * the AnswerFactory allows user to post answers to questions
 */
contract AnswerFactory is QuestionFactory {

    /*
     * NewAnswer is emited whenever a NewAnswer and it's addition to the bounty is successfully posted.
     */
    event NewAnswer(uint questionId, uint answerId, address answerer);

    /*
     * Answer struct tracks owner and upvotes. 
     */
    struct Answer {
        address owner;
        uint upvotes;
    }

    /*
     * answerIdToQuesionsId can take any answerId and map it to it's corresponding question.
     */
    mapping(uint => uint) public answerIdToQuestionId;

    /*
     * similar to questions all answers are stored in an array as they are succesfully posted
     */
    Answer[] public answers;

    /*
     * createAnswer checks to make sure the min value is sent.  Then it pushes the answer to answers and adds
     * it to the mapping.  Finally it emits that a new answer was successfully posted.
     */
    function createAnswer(uint _questionId) public payable questionOpen(_questionId) {
        require(msg.value >= questions[_questionId].answerFee);
        
        uint id = answers.push(Answer(msg.sender, 0)) - 1;
        answerIdToQuestionId[id] = _questionId;
        
        emit NewAnswer(_questionId, id, msg.sender);
    }
}