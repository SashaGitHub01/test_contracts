const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Test", () => {
  let acc1;
  let acc2;
  let test;

  beforeEach(async () => {
    [acc1, acc2] = await ethers.getSigners();
    const TestContract = await ethers.getContractFactory("Test", acc1);
    test = await TestContract.deploy();
    await test.deployed();
  });

  const sendMoney = async (sender) => {

  }

  it("is deployed", async () => {
    expect(test.address).to.be.properAddress;
  });

  it("default balance", async () => {
    const balance = await test.contractBalance();
    expect(balance).to.equal(0);
  });

  it("pay transaction", async () => {
    const tx = await test.pay("Hey", { value: 500 });
    const balance = await test.contractBalance();
    expect(balance).to.equal(500);
  });

  it("pay transaction from acc2", async () => {
    const tx = await test.connect(acc2).pay("Hey", { value: 100 });

    expect(tx.from).to.eql(acc2.address);
  });

  it("change balance", async () => {
    const tx = await test.connect(acc2).pay("Hey", { value: 100 });

    await expect(() => tx).to.changeEtherBalance(acc2, -100);
  });

  it("change balances", async () => {
    const val = 100;
    const tx = await test.connect(acc1).pay("Hey 2nd", { value: val });

    await expect(() => tx).to.changeEtherBalances([acc1, test], [-val, val]);
  });

  it("get payment", async () => {
    const msg = "Hey"
    const tx = await test.connect(acc2).pay(msg, { value: 100 });
    const payment = await test.getPayment(acc2.address, 0);

    expect(payment.message).to.eq(msg)
    expect(payment.value).to.eq(100)
  });

  it("get payment", async () => {
    const msg = "Hey"
    const tx = await test.connect(acc2).pay(msg, { value: 100 });
    const payment = await test.getPayment(acc2.address, 0);

    expect(payment.message).to.eq(msg)
    expect(payment.value).to.eq(100)
  });
});
