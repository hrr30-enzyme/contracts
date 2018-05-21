# QuestionFactory Contract

## EVENTS

### NewQuestion

Emitted when a new question is posted.

## ONLY OWNER FUNCTIONS

### setMinBounty

Sets the minimum amount needed to post a question.

### setDuration

Sets the length of time a question is live.

## PUBLIC FUNCTIONS

### getMinBounty, getDuration, getAnswerFee

Returns these values.

### newQuestion

Creates a new question wtiht he bounty sent to the ether sent.

## MODIFIERS

onlyOwner and questionOpen.

# AnswerFactory Contract

## EVENTS

### NewAnswer

Emitted when a newAnswer is posted.

## PUBLIC FUNCTIONS

## createAnswer

Creates a new answer.  The user must send at least the answerFee.

# UpVote Contract

## EVENTS

### NewVote

Emitted whenever a new vote is cast.

## PRIVATE FUNCTIONS

### didVote

A internal view function that checks to see if a address has voted yet.

## OnlyOwner Functions

### giveRightToVote

Gives a ethereum address the right to vote on questions along with how much weight their vote has.

## PUBLIC FUNCTIONS

### upVote

Increases vote count of a question based on how much weight that ethereum address was given.

### payoutWinner

Can be called anytime after the question has closed.  Calculates the highest upvoted answer and pays the the sum of all the bounties for that question and it's answers out to the winner.
