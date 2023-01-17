const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Auctions", () => {
  let owner;
  let buyer;
  let seller;
  let auctions;

  beforeEach(async () => {
    [owner, buyer, seller] = await ethers.getSigners();
    const Auctions = await ethers.getContractFactory("Auctions", owner);
    auctions = await Auctions.deploy();
    await auctions.deployed();
  });

  const getTimestamp = async (num) => {
    return (await ethers.provider.getBlock(num)).timestamp;
  };

  it("create auction", async () => {
    const dr = 100;
    const name = "test item";
    const price = ethers.utils.parseEther("0.1");

    const tx = await auctions.createAuction(dr, price, 5, name);
    const newAuct = await auctions.auctions(0);

    const ts = await getTimestamp(tx.blockNumber);

    expect(newAuct.endAt).to.be.eq(ts + dr);

    await expect(tx)
      .to.emit(auctions, "AuctionCreated")
      .withArgs(0, name, price, dr);
  });
});
