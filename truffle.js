module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*" 
    },
    rinkeby: {
      network_id: 4,
      host: '127.0.0.1',
      port: 8545,
      gas: 4000000
    }
  }
};
