// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.19;

import {VRFCoordinatorV2Interface} from
    "../../lib/chainlink-brownie-contracts/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";

import {IERC721} from "../../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";

interface ICoffeNFT is IERC721 {
    function getVrfCoordinatorAddress() external view returns (VRFCoordinatorV2Interface);

    function getMaxMintAmount() external view returns (uint256);

    function getTokenIds() external view returns (uint256);

    function getGasLane() external view returns (bytes32);

    function getSubId() external view returns (uint64);

    function getRequestConfirmations() external pure returns (uint16);

    function getCallbackGasLimit() external view returns (uint32);

    function getMintPrice() external view returns (uint256);

    function getMintStatus() external view returns (bool);

    function getTokenUris() external view returns (string memory);

    function getMintAmount(address _address) external view returns (uint32);

    function getTotalSupply() external view returns (uint256);

    function getReservedSupply() external view returns (uint256);

    function getCurrentSupply() external view returns (uint256);
}
