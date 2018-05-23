pragma solidity ^0.4.23;

import "./AnswerFactory.sol";

/*
 * The upvote contract allows users to upvote their favorite answers.
 * Users must be given the ability to vote by the Owner of the contract
 * they are only allowed to vote once per question.
 * A future edition of this contract plans on implementing a single transferable vote
 * as well as making reputation and ability to vote more decentralized
 *
 */
contract UpVote is AnswerFactory {

    /*
     * information for each vote and the voters is stored in a mix of structs and mappings.
     * the Vote struct stores the address of the voter and which answr they voted for.
     */     
    struct Vote {
        address voter;
        uint answerId;
    }

    /*
     * just like answers and questions all Votes are stored in an array.
     */
    Vote[] public votes;

    /*
     * all questions can find the indexes of their votes with the questionIdToVoteIds mapping
     */
    mapping(uint => uint[]) public questionIdToVoteIds;

    /*
     * Reputation is the weight of a voters vote.   They must be given a reputation of at least 1 by the owner
     * to be able to vote on any answer.
     */
    mapping(address => uint) public reputation;

    /*
     * NewVote is emitted to the network whenever a vote is successfully posted
     */
    event NewVote(uint questionId, uint answerId, address answerer, uint _weight);

    /*
     * giveRightToVote is how the owner gives users the ability to vote.
     */

    /*
     *
     * WARNING WARNING WARNING WARNING!
     * WARNING WARNING WARNING WARNING!
     *
     * this should be a onlyOwner function in production
     */
    function giveRightToVote(address _voter, uint16 _reputation) public  {
        reputation[_voter] = _reputation;
    }

    /*
     * didVote is a helperfunction only used to check to see if a user already voted in the 
     * upVote function.  It is declared as an view function to save gas.
     * it loops through all the questionVotes to see if the user is one of them.
     * Though this method seems inefficient compared to making a special mapping or array for this
     * functionality, it is preferable because storage on the blockchain is the a more expensive operation
     * in terms of gas than a O(n) for loop.
     */
    function didVote(uint _questionId, address _voter) internal view returns (bool) {
        uint[] memory _questionVotes = questionIdToVoteIds[_questionId];

        for (uint i = 0; i < _questionVotes.length; i++) {
            address voted = votes[_questionVotes[i]].voter;
            if (_voter == voted) {
                return true;
            }
        }
        return false;
    } 

    /*
     * upVote allows users to vote for their favorite answer.
     * first it makes sure the ethereum address has voting priveleges and hasn't voted yet.
     * then it pushes the vote to both the votearray and the questionIdToVoteIds array
     * it updates how many upvotes the answer has and then finally emits a NewVote event to the network
     */
    function upVote(uint _answerId) public questionOpen(answerIdToQuestionId[_answerId]) {
        uint _questionId = answerIdToQuestionId[_answerId];
        uint _weight = reputation[msg.sender];

        require(_weight > 0, "Do not have permission to vote");        
        require(!didVote(_questionId, msg.sender), "cannot vote twice");

        uint _voteId = votes.push(Vote(msg.sender, _answerId)) - 1;
        questionIdToVoteIds[_questionId].push(_voteId);
        answers[_answerId].upvotes = answers[_answerId].upvotes + _weight;
        
        emit NewVote(_questionId, _answerId, msg.sender, _weight);
    }

    /*
     * payoutWinner allows any users to withdraw their winnings if they get the most upvotes.
     * first the function checks to see if teh question has ended and hasn't alredy been payed out.
     * It creates a memory variable to track the bestAnswer.  memory means it doesn't write to the blockchain
     * and thus costs less gas than a storage variable.  It also tracks the winning score and the amount of bounty
     * the winner shoudl recieve.
     * If no answers have been upvoted, the bounty is sent to the user who asked the question as well as 
     * 
     * Otherwise payoutWinner loops through answers checking if the upvotes are greater than the current winner 
     * adding the answer bounties to the total bounty as it goes.
     *
     * if no answers exist or no answers have upvotes, the bounty is refunded to the questionAsker
     * otherwise the best answer is payed out. 
     */
    function payoutWinner(uint _questionId) public  {
        require(now > questions[_questionId].endTime);
        require(!questions[_questionId].payedOut, "Question already payed out");

        Answer memory bestAnswer;
        uint winningScore = 0;
        uint winningBounty = questions[_questionId].bounty;
        uint answerFee = questions[_questionId].answerFee;
        
        for (uint i = 0; i < answers.length; i++) {
            if (answerIdToQuestionId[i] == _questionId) {
                winningBounty = winningBounty + answerFee;
                if(answers[i].upvotes > winningScore) {
                    winningScore = answers[i].upvotes;
                    bestAnswer = answers[i];
                }
            }
        }
        questions[_questionId].payedOut = true;
        if (winningScore == 0) {
            questions[_questionId].asker.transfer(winningBounty);
        } else {
            bestAnswer.owner.transfer(winningBounty);           
        }
    }
}