// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script, console} from "../lib/forge-std/src/Script.sol";
import {CoffeDrop} from "../src/CoffeDrop.sol";
import {CoffeCoin} from "../src/CoffeCoin.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployCoffe is Script {
    address public coffeNFTAddress;
    uint256 public amountERC20toMint;
    uint256 public deployerKey;
    string name;
    string symbol;

    function run() public returns (HelperConfig, CoffeDrop, CoffeCoin) {
        HelperConfig helperConfig = new HelperConfig();
        (coffeNFTAddress, amountERC20toMint, name, symbol, deployerKey) = helperConfig.activeNetworkConfig();

        vm.startBroadcast(deployerKey);
        CoffeCoin coffeCoin = new CoffeCoin(amountERC20toMint, name, symbol);
        CoffeDrop coffeDrop = new CoffeDrop(coffeNFTAddress, address(coffeCoin));
        // set the airdrop contract as controller
        coffeCoin.setControllerAddress(address(coffeDrop));
        vm.stopBroadcast();

        return (helperConfig, coffeDrop, coffeCoin);
    }
}
