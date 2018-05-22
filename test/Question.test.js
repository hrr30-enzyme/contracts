const UpVote = artifacts.require('./UpVote.sol');
/*
 * Writing a test using javascript jest
 */
Contract('UpVote', (accounts) => {

  it('...should create a question.', async () => {
    const instance = await UpVote.deployed();

    await instance.newQuestion({from: accounts[0]});
    const qLength = await instance.getQuestionsCount();
    assert.equal(web3.toUtf8(qLength), '1');
  });
});