import hre from "hardhat";

async function main() {
  const [deployer] = await hre.viem.getWalletClients();
  const publicClient = await hre.viem.getPublicClient();


const mcpProvider = await hre.viem.deployContract("McpProvider", [], {
  client:{
    wallet: deployer,
    public: publicClient
  }
});

console.log(`✅ McpProvider deployed at: ${mcpProvider.address}`);

const mcpRequester= await hre.viem.deployContract("McpRequester", [], {
  client:{
    wallet: deployer,
    public: publicClient
  }
});

console.log(`✅ McpRequester deployed at: ${mcpRequester.address}`);
};

main().catch(error => {
  console.error("🚨 Deployment failed:", error);
  process.exitCode = 1;
});