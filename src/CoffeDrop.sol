// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {ICoffeNFT} from "./Interface/ICoffeNFT.sol";
import {CoffeCoin} from "./CoffeCoin.sol";

contract CoffeDrop {
    error CoffeDrop__OnlyOwnerCanCallThis();
    error CoffeDrop__FirstUpdateTheArray();

    ICoffeNFT public coffeeNFT;
    CoffeCoin public coffeeCoin;

    address[] private s_holders;

    address public immutable i_owner;

    constructor(address _coffeeNFT, address _coffeeCoin) {
        coffeeNFT = ICoffeNFT(_coffeeNFT);
        coffeeCoin = CoffeCoin(_coffeeCoin);
        i_owner = msg.sender;
    }

    modifier onlyOwner() {
        if (msg.sender != i_owner) {
            revert CoffeDrop__OnlyOwnerCanCallThis();
        }
        _;
    }

    function getNumberOfNfts() public view returns (uint256) {
        return coffeeNFT.getTokenIds();
    }

    function createArrayBasedOnNumberOfHolders() public onlyOwner returns (address[] memory) {
        uint256 numberOfNfts = getNumberOfNfts();
        for (uint256 i = 1; i < numberOfNfts + 1; i++) {
            // nft IDs start from 1
            s_holders.push(coffeeNFT.ownerOf(i));
        }
        return s_holders;
    }

    function airdropERC20token() external onlyOwner returns (bool) {
        createArrayBasedOnNumberOfHolders();
        for (uint256 i = 0; i < s_holders.length; i++) {
            bool success = coffeeCoin.mintCoins(s_holders[i]);
            if (!success) {
                return false;
            }
        }
        return true;
    }
}
