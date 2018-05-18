pragma solidity ^0.4.23;

import "./AnswerFactory.sol";

contract UpVote is AnswerFactory {
    
    struct Voter {
        uint vote;
        bool voted;
        uint reputation;
    }

    mapping(address => Voter) public voters;

    function giveRightToVote(address _voter, uint _reputation) public onlyOwner {
        voters[_voter].reputation = _reputation;
    }

    function upVote(uint _answerId) public {
        Voter storage sender = voters[msg.sender];
        require(!sender.voted, "cannot vote twice");
        sender.voted = true;
        sender.vote = _answerId;

        answers[_answerId].upvotes += sender.reputation;
    }

    function payoutWinner() public {
        require(now > endTime);
        if (answers.length <= 1) {
            endTime = now + 1 days;
            revert();
        }
        uint _winningVotes = 0;
        uint winner;
        for (uint a = 0; a < answers.length; a++) {
            if (answers[a].upvotes > _winningVotes) {
                _winningVotes = answers[a].upvotes;
                winner = a;
            }
        }
        answerToOwner[a].transfer(this.balance);
    }
}