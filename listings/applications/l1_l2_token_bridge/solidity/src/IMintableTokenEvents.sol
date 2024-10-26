// SPDX-License-Identifier: MIT.
pragma solidity ^0.8.0;

interface IMintableTokenEvents {
    event Minted(address indexed account, uint256 amount);
    event Burned(address indexed account, uint256 amount);
}
