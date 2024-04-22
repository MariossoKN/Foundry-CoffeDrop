// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "../lib/forge-std/src/Script.sol";
import {ERC721Mock} from "../test/mock/ERC721Mock.sol";

contract HelperConfig is Script {
    NetworkConfig public activeNetworkConfig;
    ERC721Mock public COFFEE_NFT;

    uint256 public constant DEFAULT_ANVIL_PRIVATE_KEY =
        0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;

    struct NetworkConfig {
        address coffeNFTAddress;
        uint256 amountERC20toMint;
        string name;
        string symbol;
        uint256 deployerKey;
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaConfig();
        } else if (block.chainid == 1) {
            activeNetworkConfig = getMainnetConfig();
        } else {
            activeNetworkConfig = getAnvilConfig();
        }
    }

    function getSepoliaConfig() public view returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaNetworkConfig = NetworkConfig({
            coffeNFTAddress: 0x0A0FFC575d3DBB988E5B9A81Ea815CD4C23A2dd0,
            amountERC20toMint: 10,
            name: "CoffeCoin",
            symbol: "COFFEE",
            deployerKey: vm.envUint("PRIVATE_KEY")
        });
        return sepoliaNetworkConfig;
    }

    function getMainnetConfig() public view returns (NetworkConfig memory) {
        NetworkConfig memory mainnetNetworkConfig = NetworkConfig({
            coffeNFTAddress: 0x0000000000000000000000000000000000000000,
            amountERC20toMint: 10,
            name: "CoffeCoin",
            symbol: "COFFEE",
            deployerKey: vm.envUint("PRIVATE_KEY")
        });
        return mainnetNetworkConfig;
    }

    function getAnvilConfig() public returns (NetworkConfig memory) {
        vm.startBroadcast(DEFAULT_ANVIL_PRIVATE_KEY);
        COFFEE_NFT = new ERC721Mock();
        vm.stopBroadcast();

        NetworkConfig memory anvilNetworkConfig = NetworkConfig({
            coffeNFTAddress: address(COFFEE_NFT),
            amountERC20toMint: 10,
            name: "CoffeCoin",
            symbol: "COFFEE",
            deployerKey: DEFAULT_ANVIL_PRIVATE_KEY
        });
        return anvilNetworkConfig;
    }

    function getActiveConfig() public view returns (NetworkConfig memory) {
        return activeNetworkConfig;
    }
}
