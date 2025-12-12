// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "openzeppelin-contracts/contracts/utils/Pausable.sol";

contract NftCollection is ERC721, ERC721Burnable, Ownable, Pausable {

    uint256 public immutable maxSupply;
    uint256 private _totalSupply;
    string private _baseTokenURI;

    error ExceedsMaxSupply();
    error InvalidTokenId();
    error ZeroAddress();

    event BaseURIChanged(string newBaseURI);

    constructor(
        string memory name_,
        string memory symbol_,
        uint256 maxSupply_,
        string memory baseURI_
    )
        ERC721(name_, symbol_)
        Ownable(msg.sender)   // ✅ REQUIRED FOR OZ v5
    {
        require(maxSupply_ > 0, "maxSupply > 0");
        maxSupply = maxSupply_;
        _baseTokenURI = baseURI_;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function safeMint(address to, uint256 tokenId)
        external
        onlyOwner
        whenNotPaused
    {
        if (to == address(0)) revert ZeroAddress();
        if (tokenId == 0 || tokenId > maxSupply) revert InvalidTokenId();
        if (_ownerOf(tokenId) != address(0)) revert InvalidTokenId();
        if (_totalSupply + 1 > maxSupply) revert ExceedsMaxSupply();

        _safeMint(to, tokenId);
        _totalSupply++;
    }

    function burn(uint256 tokenId) public override {
        super.burn(tokenId);
        _totalSupply--;
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function _baseURI() internal view override returns (string memory) {
        return _baseTokenURI;
    }

    function setBaseURI(string calldata newBaseURI)
        external
        onlyOwner
    {
        _baseTokenURI = newBaseURI;
        emit BaseURIChanged(newBaseURI);
    }

    function _update(address to, uint256 tokenId, address auth)
        internal
        override
        returns (address)
    {
        if (paused()) revert("paused");
        return super._update(to, tokenId, auth);
    }
}
