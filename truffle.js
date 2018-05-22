module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*" // Match any network id
    },
    rinkeby: {
      network_id: 4,
      host: '127.0.0.1',
      port: 8545,
      gas: 4000000
    }
  }
};

// geth --rinkeby --rpc --rpcapi="personal,eth,network,web3,net" --ipcpath "~/.ethereum/"
// mute logs geth console 2>> /dev/null