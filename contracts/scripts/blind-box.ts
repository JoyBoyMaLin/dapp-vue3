import { ethers } from "hardhat";

async function main() {
  const BlindBox = await ethers.getContractFactory("BlindBox");
  const blindBox = await BlindBox.attach(
    "0xb2D1ef6A70A0b49d941a61d2D1537fdeb692C687"
  );
  // const mint = await blindBox.mintBoxNftMeta({
  //   value: ethers.utils.parseEther("0.01"),
  // });
  // console.log(mint);
  const open = await blindBox.openBox(0);
  console.log(open);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
