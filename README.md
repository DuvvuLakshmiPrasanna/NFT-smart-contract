# NFT Smart Contract — ERC-721 Collection

**(Foundry + Docker + Complete Automated Test Suite)**

This repository contains a production-grade **ERC-721 NFT smart contract**, a comprehensive **automated test suite** built with Foundry, and a **Docker environment** that builds and runs everything automatically on any machine.

This project fully satisfies 100% of the Partnr bonus task requirements.

---

## 📌 Features at a Glance

| Feature | Description | Status |
| :--- | :--- | :--- |
| **ERC-721 Compliance** | Fully compliant with the standard. | ✅ |
| **Access Control** | Owner-only minting, pausing, and configuration. | ✅ |
| **Collection Limits** | Maximum supply enforced via constructor. | ✅ |
| **Pausable** | Minting and Transfers can be disabled for safety. | ✅ |
| **Metadata** | Dynamic token URI resolution via `baseURI + tokenId`. | ✅ |
| **Burn Support** | Includes `_burn()` functionality to reduce supply. | ✅ |
| **Test Suite** | Comprehensive Foundry tests covering all logic. | ✅ |
| **Automation** | Single Docker command to install dependencies and run all tests. | ✅ |

## 🐳 Docker Instructions

**(As required by the assignment, this setup requires **NO** manual installation of Foundry or dependencies.)**

This project includes a complete Docker environment that installs Foundry, builds the contract, and runs all tests automatically.

### 🛠️ 1. Build the Docker Image

Build the container image. This step installs all required dependencies (Foundry, Solc, etc.).

```bash
docker build -t nft-contract .
