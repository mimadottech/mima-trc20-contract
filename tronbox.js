module.exports = {
  networks: {
    development: {
// For trontools/quickstart docker image
      privateKey: 'privatekey',
      consume_user_resource_percent: 30,
      fee_limit: 100000000,
      fullNode: "http://127.0.0.1:8090",
      solidityNode: "http://127.0.0.1:8091",
      eventServer: "http://127.0.0.1:8092",
      network_id: "*"
    },
    shasta: {
      privateKey:'privatekey',
      userFeePercentage: 50,
      feeLimit: 1e8,
      fullHost: 'https://api.shasta.trongrid.io',
      network_id: '2'
    },
    mainnet: {
      // Don't put your private key here:
      privateKey: 'privatekey',
      /*
Create a .env file (it must be gitignored) containing something like
  export PRIVATE_KEY_MAINNET=4E7FECCB71207B867C495B51A1D4422088A87F4978BE64636656243
Then, run the migration with:
  source .env && tronbox migrate --network mainnet
*/
      userFeePercentage: 100,
      feeLimit: 1e8,
      fullHost: 'https://api.trongrid.io',
      network_id: '1'
    }
  },compilers: {
    solc: {
      version: "0.4.24"  // ex:  "0.4.20". (Default: Truffle's installed solc)
    }
 }
};
