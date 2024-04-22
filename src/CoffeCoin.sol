// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {ERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract CoffeCoin is ERC20 {
    error CoffeCoin__CanOnlyBeCalledByCoffeDropContract();
    error CoffeCoin__ControllerAddressMustBeFirstSet();
    error CoffeCoin__CantBeZeroAddress();
    error CoffeCoin__CanOnlyBeCalledByOwner();

    address public immutable i_owner;

    address private s_controllerAddress;
    uint256 private s_amountToMint;

    constructor(uint256 _amountToMint, string memory _name, string memory _symbol) ERC20(_name, _symbol) {
        s_amountToMint = _amountToMint;
        i_owner = msg.sender;
    }

    function mintCoins(address _to) external returns (bool) {
        if (s_controllerAddress == address(0)) {
            revert CoffeCoin__ControllerAddressMustBeFirstSet();
        }
        if (msg.sender != s_controllerAddress) {
            revert CoffeCoin__CanOnlyBeCalledByCoffeDropContract();
        }
        _mint(_to, s_amountToMint);
        return true;
    }

    function setControllerAddress(address _controllerAddress) external {
        if (msg.sender != i_owner) {
            revert CoffeCoin__CanOnlyBeCalledByOwner();
        }
        if (s_controllerAddress != address(0)) {
            revert CoffeCoin__CantBeZeroAddress();
        }
        s_controllerAddress = _controllerAddress;
    }
}
