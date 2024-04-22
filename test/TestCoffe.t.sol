// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "../../lib/forge-std/src/Test.sol";
import {DeployCoffe} from "../script/DeployCoffe.s.sol";
import {CoffeDrop} from "../src/CoffeDrop.sol";
import {CoffeCoin} from "../src/CoffeCoin.sol";
import {ERC721Mock} from "../test/mock/ERC721Mock.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";

contract TestCoffe is Test {
    DeployCoffe deployCoffe;
    HelperConfig helperConfig;
    CoffeDrop coffeDrop;
    CoffeCoin coffeCoin;

    address coffeNFTAddress;
    uint256 amountERC20toMint;
    uint256 deployerKey;
    address owner;

    address MINTER1 = makeAddr("MINTER1");
    address MINTER2 = makeAddr("MINTER2");
    uint256 mintAmount1 = 5;
    uint256 mintAmount2 = 10;

    function setUp() public {
        deployCoffe = new DeployCoffe();
        (helperConfig, coffeDrop, coffeCoin) = deployCoffe.run();
        (coffeNFTAddress, amountERC20toMint,,, deployerKey) = helperConfig.activeNetworkConfig();
        vm.prank(MINTER1);
        ERC721Mock(coffeNFTAddress).mintNft(MINTER1, mintAmount1);
        ERC721Mock(coffeNFTAddress).mintNft(MINTER2, mintAmount2);
        owner = coffeDrop.i_owner();
    }

    /////////////////////
    // ERC721Mock test //
    /////////////////////
    function testNFTHolders() public view {
        for (uint256 i = 1; i < mintAmount1 + 1; i++) {
            assertEq(ERC721Mock(coffeNFTAddress).ownerOf(i), MINTER1);
        }
        for (uint256 i = mintAmount1 + 1; i < mintAmount1 + mintAmount2; i++) {
            assertEq(ERC721Mock(coffeNFTAddress).ownerOf(i), MINTER2);
        }
    }

    function testTokenIds() public view {
        assertEq(ERC721Mock(coffeNFTAddress).tokenIds(), mintAmount1 + mintAmount2);
    }

    ////////////////////
    // CoffeDrop test //
    ////////////////////
    // getNumberOfNfts test //
    function testReturnsTheNumberOfNftsMinted() public view {
        assertEq(coffeDrop.getNumberOfNfts(), mintAmount1 + mintAmount2);
    }

    // createArrayBasedOnNumberOfHolders test //
    function testReturnsAnArrayOfHolders() public {
        vm.startPrank(owner);
        address[] memory holders = coffeDrop.createArrayBasedOnNumberOfHolders();
        assertEq(holders.length, mintAmount1 + mintAmount2);
        for (uint256 i = 0; i < mintAmount1; i++) {
            assertEq(holders[i], MINTER1);
        }
        for (uint256 i = mintAmount1; i < mintAmount1 + mintAmount2; i++) {
            assertEq(holders[i], MINTER2);
        }
        vm.stopPrank();
    }

    // airdropERC20token //
    function testAirdropsERC20tokenToNftHolders() public {
        vm.startPrank(owner);
        assertEq(coffeCoin.totalSupply(), 0);
        assertEq(coffeCoin.balanceOf(MINTER1), 0);
        assertEq(coffeCoin.balanceOf(MINTER2), 0);

        coffeDrop.airdropERC20token();

        assert(coffeCoin.totalSupply() == (amountERC20toMint * mintAmount1) + (amountERC20toMint * mintAmount2));
        assert(coffeCoin.balanceOf(MINTER1) == amountERC20toMint * mintAmount1);
        assert(coffeCoin.balanceOf(MINTER2) == amountERC20toMint * mintAmount2);
    }
}
