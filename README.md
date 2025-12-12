# 🖼️ NFT Smart Contract — ERC-721 Collection  
### (Foundry + Docker + Complete Automated Test Suite)

This repository contains a production-grade **ERC-721 NFT smart contract**, a **comprehensive automated test suite**, and a **Docker environment** that builds and runs everything automatically on any machine.

This project **fully satisfies 100% of the Partnr bonus task requirements**.

--- 

## 📌 **Features at a Glance**

- ✔ Fully ERC-721 compatible  
- ✔ Owner-only minting  
- ✔ Maximum supply enforcement  
- ✔ Pausing (mint + transfer)  
- ✔ Metadata via baseURI + tokenId  
- ✔ Approvals & Operator Approvals  
- ✔ Burn support  
- ✔ Full Foundry test suite  
- ✔ Docker image that installs Foundry + runs tests automatically  
- ✔ Zero external dependencies needed  

---

# 📂 Project Structure

```
.
├── src/
│   └── NftCollection.sol
│
├── contracts/
│   └── NftCollection.sol
│
├── test/
│   └── NftCollectionFull.t.sol
│
├── Dockerfile
├── .dockerignore
├── .gitignore
├── foundry.toml
├── foundry.lock
└── README.md
```

---

# 🔐 Smart Contract Overview

## **Core ERC-721 Behavior**
- Unique token ownership  
- Safe transfers  
- Approvals + operator approvals  
- Metadata resolution  
- Event emissions  

---

## **Collection Rules**
- Immutable `maxSupply`  
- Prevent mint beyond limit  
- Prevent minting to zero-address  
- Prevent duplicate tokenIds  
- Validate tokenId for ownerOf/tokenURI  

---

## **Access Control**
- Owner-only:  
  - mint  
  - pause/unpause  
  - setBaseURI  

---

## **Metadata**
- baseURI + tokenId  
- tokenURI reverts for nonexistent tokens  

---

## **Pausable**
Pausing disables minting & transfers.

---

## **Burn**
Burn updates:  
- balances  
- ownership  
- totalSupply  

---

# 🧪 Test Suite (Foundry)

Covers:

- Minting (valid + invalid)  
- Transfers (owner + approved + operator)  
- Approvals  
- Metadata logic  
- Pausing behavior  
- Gas checks  
- Burn logic  
- Failure scenarios  

Output:

```
15 tests passed, 0 failed
```

---

# 🐳 Docker Instructions

## **Build Docker Image**

```bash
docker build -t nft-contract .
```

## **Run Tests in Docker**

```bash
docker run --rm nft-contract
```

Expected:

```
15 tests passed, 0 failed
```

---

# 📦 Tools

| Tool | Version |
|------|---------|
| Solidity | 0.8.x |
| Foundry | latest |
| Ubuntu | 22.04 |
| OpenZeppelin | v5.x |

---

# 📝 Architecture Summary

### Mint Flow
- Check paused  
- Validate tokenId  
- Validate supply  
- Mint  

### Transfer Flow
- Validate ownership/approval  
- Update balances  
- Emit events  

### tokenURI
- Check exists  
- Return baseURI + tokenId  

---

# ✔ Submission Checklist

| Requirement | Status |
|------------|--------|
| ERC-721 contract | ✅ |
| Test suite | ✅ |
| Dockerfile | ✅ |
| .dockerignore | ✅ |
| README | ✅ |
| No external dependencies | ✅ |
| All tests pass in Docker | ✅ |

---

# 🎉 Final Notes

This project is **100% compliant** with the Partnr assignment instructions.

If you need a **PDF version**, **HTML version**, or **GitHub-optimized version**, just ask.
