pragma solidity ^0.4.23;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/UpVote.sol";

/*
 * Using solidity to write a test
 */

contract TestContracts {
    UpVote upVote = UpVote(DeployedAddresses.UpVote());

    upVote.NewQuestion();

    uint expected = 1;

    Assert.equal(upVote.getQuestionsCount(), expected, "It should create a new question.");
}