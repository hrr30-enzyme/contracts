These contracts provide a decentralized way to post bounties on questions and compete to have the best answer to win the bounty on the Ethereum network.  To post a question a user most post an initial bounty.  To answer a question they must add to the questions bounty.   Users can also vote for the answer they believe is best, but only if their address is first approved to vote.

They were created using truffle with Ganache and tested with Remix and the Rinkeby network.

The user interface was created with React/Redux with web3.

#### URL

https://hrr30-enzyme-frontend.herokuapp.com/

## QuestionFactory Contract

### EVENTS

#### NewQuestion

Emitted when a new question is posted.

### ONLY OWNER FUNCTIONS

#### setMinBounty

Sets the minimum amount needed to post a new question.

#### setDuration

Sets the length of time a question is live for future questions.

#### setAnswerFee

Sets the fee a user must pay to answer a question in future questions.

### PUBLIC FUNCTIONS

#### getMinBounty, getDuration, getAnswerFee

Returns the current values for any future questions.

#### newQuestion

Creates a new question wtiht he bounty sent to the ether sent.

### MODIFIERS

onlyOwner and questionOpen.

## AnswerFactory Contract

### EVENTS

#### NewAnswer

Emitted when a newAnswer is posted.

### PUBLIC FUNCTIONS

### createAnswer

Creates a new answer.  The user must send at least the answerFee.

## UpVote Contract

### EVENTS

#### NewVote

Emitted whenever a new vote is cast.

### PRIVATE FUNCTIONS

#### didVote

A internal view function that checks to see if a address has voted yet.

### OnlyOwner Functions

#### giveRightToVote

Gives a ethereum address the right to vote on questions along with how much weight their vote has.

### PUBLIC FUNCTIONS

#### upVote

Increases vote count of a question based on how much weight that ethereum address was given.

#### payoutWinner

Can be called anytime after the question has closed.  Calculates the highest upvoted answer and pays the the sum of all the bounties for that question and it's answers out to the winner.
