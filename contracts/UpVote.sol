pragma solidity ^0.4.23;

import "./AnswerFactory.sol";

contract UpVote is AnswerFactory {

    uint startingReputation = 1;

    function setStartingReputation(uint _startingReputation) public onlyOwner {
        startingReputation = _startingReputation;
    }

    struct Vote {
        address voter;
        uint answerId;
    }

    Vote[] public votes;

    mapping(uint => uint[]) public questionIdToVoteIds;

    mapping(address => uint) public reputation;

    event NewVote(uint questionId, uint answerId, address answerer, uint _weight);

    function giveRightToVote(address _voter, uint16 _reputation) public onlyOwner {
        reputation[_voter] = _reputation;
    }

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

    function payoutWinner(uint _questionId) public  {
        Question memory _question = questions[_questionId];

        require(now > _question.endTime, "Question hasn't ended yet");
        require(!_question.payedOut, "Question already payed out");

        Answer memory bestAnswer;
        uint winningScore = 0;

        if (questionIdToVoteIds[_questionId].length == 0) {
            _question.asker.transfer(address(this).balance);
        } else {
            for (uint i = 0; i < answers.length; i++) {
                if (answerIdToQuestionId[i] == _questionId) {
                    if(answers[i].upvotes > winningScore) {
                        winningScore = answers[i].upvotes;
                        bestAnswer = answers[i];
                    }
                }
            }
            bestAnswer.owner.transfer(address(this).balance);           
        }
    }
}