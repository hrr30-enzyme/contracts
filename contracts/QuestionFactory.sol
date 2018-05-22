pragma solidity ^0.4.23;

import "./zeppelin/ownership/Ownable.sol";

/*
 *
 * Question Factory allows admins to change settings for future 
 * questions and allow users to post questions
 *
 */

contract QuestionFactory is Ownable {

    uint minBounty = 100000000000000 wei;
    uint duration = 1 days;
    uint answerFee = 10000000000000 wei;

    /*
     * NewQuestion is emited everytime a new question bounty is succesfully added
     */

    event NewQuestion(
        uint questionId,
        uint endTime,
        uint bounty,
        address asker,
        uint answerFee
    );
    
    /*
     * our Question struct contains the data stored in our question
     */

    struct Question {
        uint endTime;
        uint bounty;
        address asker;
        uint answerFee;
        bool payedOut;
    }

    /*
     *  All questions are stored added to an array as they are crated
     */

    Question[] public questions;

    /*
     * the questionsCount will return how many questions have been ever been posted
     */ 

    function getQuestionsCount() public view returns (uint) {
        return questions.length;
    }

    /*
     * the minBounty is the minimum amount of eth
     */ 
    function getMinBounty() public view returns (uint) {
        return minBounty;
    }
    
    function setMinBounty(uint _minBounty) public onlyOwner{
        minBounty = _minBounty;
    }
    
    /*
     * the duration is how long new questions are open for voting and answering
     */
    function getDuration() public view returns (uint) {
        return duration;
    }
    
    function setDuration(uint _duration) public onlyOwner {
        duration = _duration;
    }
    
    /*
     * the answer fee is the min amount of ether needed to answer a question on the blockchain.
     */
    function getAnswerFee() public view returns (uint) {
        return answerFee;
    }
    
    function setAnswerFee(uint _answerFee) public onlyOwner {
        answerFee = _answerFee;
    }

    /*
     * newQuestion gets called when a user wants to post a new bounty.
     * First it makes sure teh min value is sent in the transaction.
     * then it sets the endTime and pushes the question to the questions Array.
     * finally it emits that the NewQuestion event to the network.
     */
    function createQuestion() public payable {

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

    /*
     * The ethereum account that deployed the contract is able to use onlyOwner functions such as changing
     * the min bounties for future questions and approving ethereum accounts to have voting priveleges.
     * The functionality of the owner comes from the Ownable contract from the Open Zeppelen library.
     *
     */
    constructor() public {
        owner = msg.sender;
    }

    /*
     * The questionOpen modifier can be added to function signitures to require that the questions endTime has not
     * passed when a user is trying to post a new answer or a  new upvote.
     *
     */

    modifier questionOpen(uint _questionId) {
        require(now <= questions[_questionId].endTime);
        _;
    }
}

