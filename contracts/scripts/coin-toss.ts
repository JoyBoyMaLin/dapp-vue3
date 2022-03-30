import { ethers } from "hardhat";

async function main() {
  // const VRFv2SubscriberManager = await ethers.getContractFactory(
  //   "VRFv2SubscriptionManager"
  // );
  // const manager = await VRFv2SubscriberManager.attach(
  //   "0x6e8245833B4EeDc5aCc581dB99D873CBb3029f37"
  // );
  // console.log(await manager.functions.s_subscriptionId());
  // const CoinToss = await ethers.getContractFactory("CoinToss");
  // const coinToss = await CoinToss.deploy(1872);
  //
  // await coinToss.deployed();
  // console.log(coinToss.address);
  // await manager.functions.addConsumer(coinToss.address);
  // const joinLog = await coinToss.functions.join({
  //   value: ethers.utils.parseEther("0.1"),
  // });
  const CoinToss = await ethers.getContractFactory("CoinToss");
  const coinToss = await CoinToss.attach(
    "0x8Fbeb009Fa54f6cFAb19ab231C1Fd53A5cE176CC"
  );
  const joinLog = await coinToss.functions.join({
    value: ethers.utils.parseEther("5"),
  });
  console.log(joinLog);
  const events = await coinToss.filters.DiceLanded();
  await coinToss.on(events, (requestId, roller, guess, rollValue) => {
    console.log(requestId, roller, guess, rollValue);
  });
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
