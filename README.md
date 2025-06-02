# 🧠 MCP Protocol — Minimal Viable Registry

[![Solidity](https://img.shields.io/badge/Solidity-0.8.30-blue?logo=ethereum)](https://docs.soliditylang.org)
[![Hardhat](https://img.shields.io/badge/Hardhat-dev-yellow)](https://hardhat.org)
[![Chainlink](https://img.shields.io/badge/Chainlink-Data-Feeds)](https://chain.link/data-feeds)
[![Chainlink](https://img.shields.io/badge/Chainlink-Functions-blue)](https://chain.link/functions)
[![Chainlink](https://img.shields.io/badge/Chainlink-Automation-blue)](https://chain.link/automation)
[![Docker](https://img.shields.io/badge/Docker-Container-blue?logo=docker)](https://docker.com)
[![MCP](https://img.shields.io/badge/MCP-Registry-critical)](#)

---

# What is MCP?
Model Context Protocol is a new open standard for AI models to interact with external data and services. For more informaion, check out [this](https://www.youtube.com/watch?v=HyzlYwjoXOQ) video. 

# Peer-to-peer MCP Protocol 
A minimal viable decentralized market for MCPs services, enabling decentralized service discovery and request routing.
This project serves as a foundational layer for building a decentralized marketplace for AI APIs, allowing providers to register their services and consumers to request them.
We believe this service will be valuable for the Blockchain x AI ecosystem, enabling efficient, cost effective, democratic and decentralized access to computing resources.

# MCP examples (clickable links)

<a href="https://github.com/BlindVibeDev/CoinGeckoMCP" target="_blank">
  <img src="./assets/CoinGecko_logo.png" alt="Coingecko_Logo" width="100"/>
</a>
<a href="https://hub.docker.com/r/mcp/notion" target="_blank">
  <img src="./assets/Notion_app_logo.png" alt="Notion_Logo" width="100"/>
</a>
<a href="https://hub.docker.com/r/mcp/postgres" target="_blank">
  <img src="./assets/Postgresql_elephant.svg.png" alt="Postgres_Logo" width="100"/>
</a>


## 🧱 Architecture Overview

![MCP Contract Flow](./assets/r-r.gif)

---

## 🔩 Component Breakdown

### 🔵 McpProvider.sol
- Provider-side registry of MCP service metadata.
- Stores `httpsURI` and `registeredAt` per submission.
- Uses `msg.sender` as the primary identity.

```solidity
struct McpMetadata {
    address owner;
    string httpsURI;
    uint256 registeredAt;
}
```

### 🟢 McpConsumer.sol
- Queries the provider contract for valid `httpsURI`.
- Emits an `McpRequested` event to signal off-chain routing.
- Validates that the provider exists before emitting request.

---

## 🛠 Getting Started

### Prerequisites

```bash
# Hardhat Project Init
npm install --save-dev hardhat
npx hardhat
```

### File Structure

```
contracts/
├── McpProvider.sol
└── McpConsumer.sol
```

---

## 🚀 Contract Deployment (Hardhat)

```bash
# Compile contracts
npx hardhat compile

# Run tests
npx hardhat test

# Deploy
npx hardhat run scripts/deploy.js --network localhost
```

---

## 🔌 Provider Functions

| Function | Description |
|----------|-------------|
| `registerProvider(string httpsURI)` | Register a service |
| `deregisterProvider(string httpsURI)` | Stop providing services for a specific MCP |
---

## 📡 Consumer Functions

| Function | Description |
|----------|-------------|
| `requestMcpSubscription(string httpsURI)` | Subscribe to a service for 30 days |
| `endMcpSubscription(string httpsURI)` | Ends the subscription | Called by Chainlink Automation |
---

## 📖 Events

```solidity
// In McpProvider.sol
event RegistrationFailed(address indexed provider, string httpsURI, uint256 timestamp);
event ProviderRegistered(address indexed provider, string httpsURI, uint256 timestamp);
event ProviderDeregistered(address indexed provider, string httpsURI, uint256 timestamp);

// In McpConsumer.sol
event RequestFailed(address indexed requester, string httpsURI, uint256 timestamp);
event McpRequested(address indexed requester, string httpsURI, uint256 timestamp);
event McpRequestEnded(address indexed requester, string httpsURI, uint256 timestamp);

```

---

## 🧪 Testing

```bash
npx hardhat test
```

Unit tests should:
- Register multiple providers
- Prevent duplicate logic (if added)
- Emit request events
- Cross-reference valid providers

---

## 🛡 Security Notes

- Only `msg.sender` can register
- Optionally add stake + slashing
- Consumer checks must prevent spoofed requests

---

## 📚 Future Work

- Cross-chain support via Chainlink CCIP
- Inspector verification system (current model suffers from trust based assumptions)
- Reputation system for providers
- SLA enforcement
- Custom pricing models
---

For now, this is the **minimum viable project** to anchor the MCP marketplace.