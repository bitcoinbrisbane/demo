const Token = artifacts.require("Token");
//const assertJump = require("./assertJump.js");
const tokenName = 'Token name';
const decimalUnits = 6;
const tokenSymbol = 'TCK';

const durationTime = 28; //4 weeks

const timeController = (() => {
  
    const addSeconds = (seconds) => new Promise((resolve, reject) =>
      web3.currentProvider.sendAsync({
        jsonrpc: "2.0",
        method: "evm_increaseTime",
        params: [seconds],
        id: new Date().getTime()
      }, (error, result) => error ? reject(error) : resolve(result.result)));
  
    const addDays = (days) => addSeconds(days * 24 * 60 * 60);
  
    const currentTimestamp = () => web3.eth.getBlock(web3.eth.blockNumber).timestamp;
  
    return {
      addSeconds,
      addDays,
      currentTimestamp
    };
  })();
  
async function advanceToBlock(number) {
  await timeController.addDays(number);
}

contract('Demo Token', function(accounts) {
  beforeEach(async function () {
    this.token = await ICO.new(accounts[0]);
  });

  it("should have symbol TCK", async function () {
    const actual = await this.token.symbol();
    assert.equal(actual, tokenSymbol, "Symbol should be TCK");
  });

  it("should have name token name", async function () {
    const actual = await this.token.name();
    assert.equal(actual, tokenName, "Name should be Token name");
  });

  it("should put 500,000,000 xxx to supply and in the first account", async function () {
    const balance = await this.token.balanceOf(accounts[0]);
    const supply = await this.token.totalSupply();
    assert.equal(balance.valueOf(), 500000000 * 10 ** 6, "First account (owner) balance must be 500000000000000");
    assert.equal(supply.valueOf(), 500000000 * 10 ** 6, "Supply must be 500000000000000");
  });
});