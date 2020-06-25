var KYCCrypto = artifacts.require("./KYCCrypto.sol");

module.exports = function(deployer) {

  deployer.deploy(KYCCrypto);

};
