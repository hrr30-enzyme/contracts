const UpVote = artifacts.require('./UpVote.sol');

module.exports = function(deployer) {
  deployer.deploy(UpVote);
};
