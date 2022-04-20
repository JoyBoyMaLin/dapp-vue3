// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { ethers } from "hardhat";

async function main() {
  const BlindBox = await ethers.getContractFactory("BlindBox");
  const blindBox = await BlindBox.deploy(
    "0x67A2489fa50258681A4f559277BB332b84e2C8c7"
  );

  await blindBox.deployed();

  console.log("Doll deployed to:", blindBox.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
