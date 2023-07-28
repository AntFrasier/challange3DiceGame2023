const { ethers } = require("hardhat");

const localChainId = "31337";

module.exports = async ({ getNamedAccounts, deployments, getChainId }) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  const chainId = await getChainId();

  const diceGame = await ethers.getContract("DiceGame", deployer);

  
  await deploy("RiggedRoll", {
   from: deployer,
   args: [diceGame.address],
   log: true,
  });
  

  const riggedRoll = await ethers.getContract("RiggedRoll", deployer);
  console.log("waiting...");
  sleep(500);
  const ownershipTransaction = await riggedRoll.transferOwnership("0xF25189aDF5A553578d63f9F8863Fc93FAf94A65A");
  

};

function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

module.exports.tags = ["RiggedRoll"];
