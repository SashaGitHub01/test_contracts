const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Auctions", () => {
  let owner;
  let buyer;
  let seller;
  let test;

  beforeEach(async () => {
    [owner, buyer, seller] = await ethers.getSigners();
    const Auctions = await ethers.getContractFactory("Auctions", owner);
    test = await Auctions.deploy();
    await test.deployed();
  });
});
