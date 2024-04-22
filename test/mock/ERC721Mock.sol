// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract ERC721Mock is ERC721 {
    constructor() ERC721("ERC721Mock", "ERC721M") {}

    uint256 public tokenIds = 0;

    function mintNft(address account, uint256 amount) public {
        for (uint256 i = 0; i < amount; i++) {
            tokenIds++;
            _mint(account, tokenIds);
        }
    }

    function ownerOf(uint256 tokenId) public view override returns (address) {
        return _ownerOf(tokenId);
    }

    function burnNft(uint256 tokenId) public {
        _burn(tokenId);
    }

    function getTokenIds() public view returns (uint256) {
        return tokenIds;
    }
}
