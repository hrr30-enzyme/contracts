pragma solidity ^0.4.23;

import "./AnswerFactory.sol";

contract UpVote is AnswerFactory {
    
    struct Voter {
        uint vote;
        bool voted;
        uint16 reputation;
    }

    mapping(address => Voter) public voters;

    event NewVote(uint answerId, address answerer);

    function giveRightToVote(address _voter, uint16 _reputation) public onlyOwner {
        voters[_voter].reputation = _reputation;
    }

    function upVote(uint _answerId) public questionOpen {
        Voter storage sender = voters[msg.sender];
        require(!sender.voted, "cannot vote twice");
        sender.voted = true;
        sender.vote = _answerId;

        answers[_answerId].upvotes = answers[_answerId].upvotes + sender.reputation;
    }

    function payoutWinner() public  {
        require(now > endTime);
        if (answers.length < 1) {
            endTime = now + 1 days;
        } else {
            uint16 _winningVotes = 0;
            Answer memory winner;
            for (uint a = 0; a < answers.length; a++) {
                if (answers[a].upvotes > _winningVotes) {
                    _winningVotes = answers[a].upvotes;
                    winner = answers[a];
                }
            }
            winner.owner.transfer(address(this).balance);
        }
        
    }
}