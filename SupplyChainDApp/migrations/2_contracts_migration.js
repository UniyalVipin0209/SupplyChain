const Erc20Token = artifacts.require("./ERC20Token.sol");
const SupplyChain = artifacts.require("./SupplyChain"); 
module.exports = function (deployer) {
  deployer.deploy(Erc20Token, 10000, "TotalSem Token", 18, "TotalSem");
  deployer.deploy(SupplyChain);
};
