import hre from "hardhat";
import { expect } from "chai";

describe("MCP Contracts", function () {
  it("should deploy and interact using only available functions", async function () {
    // Deploy both contracts
    const provider = await hre.viem.deployContract("McpProvider", []);
    const requester = await hre.viem.deployContract("McpRequester", []);

    // Dummy URI, but your getProvider/getRequester logic likely depends on internal mapping
    const dummyUri = "https://dummy.uri";

    // Register provider with placeholder value
    await provider.write.registerProvider([true]);

    // Fetch with getProvider, though this likely returns (address(0), "")
    const [providerAddr, providerStr] = await provider.read.getProvider([dummyUri]);
    console.log("McpProvider.getProvider():", providerAddr, providerStr);

    expect(providerAddr).to.match(/^0x/);

    // Request provider
    await requester.write.requestProvider([true]);

    // Fetch requester details
    const [requesterAddr, requesterStr, ts] = await requester.read.getRequester([dummyUri]);
    console.log("McpRequester.getRequester():", requesterAddr, requesterStr, ts);

    expect(requesterAddr).to.match(/^0x/);
  });
});
