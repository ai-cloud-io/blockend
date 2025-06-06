import { ethers } from 'hardhat';

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log('Deploying contracts with:', deployer.address);

  // 1. Deploy Mock USDC
  const MockToken = await ethers.getContractFactory('ERC20Mock');
  const usdc = await MockToken.deploy(
    'Mock USDC',
    'USDC',
    deployer.address,
    ethers.parseUnits('1000000', 6),
  );
  await usdc.waitForDeployment();
  const usdcAddress = await usdc.getAddress();
  console.log('Mock USDC deployed to:', usdcAddress);

  // 2. Deploy Mock Price Feed
  const MockAggregator = await ethers.getContractFactory('MockV3Aggregator');
  const priceFeed = await MockAggregator.deploy(8, ethers.parseUnits('1', 8));
  await priceFeed.waitForDeployment();
  const priceFeedAddress = await priceFeed.getAddress();
  console.log('Mock PriceFeed deployed to:', priceFeedAddress);

  // 3. Deploy MCP Provider
  const McpProvider = await ethers.getContractFactory('McpProvider');
  const provider = await McpProvider.deploy(priceFeedAddress, usdcAddress);
  await provider.waitForDeployment();
  const providerAddress = await provider.getAddress();
  console.log('McpProvider deployed to:', providerAddress);

  // 4. Deploy MCP Requester
  const McpRequester = await ethers.getContractFactory('McpRequester');
  const requester = await McpRequester.deploy();
  await requester.waitForDeployment();
  const requesterAddress = await requester.getAddress();
  console.log('McpRequester deployed to:', requesterAddress);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
