// SPDX-License-Identifier: MIT.
pragma solidity ^0.8.0;

interface IMintableToken {
    event Minted(address indexed account, uint256 amount);
    event Burned(address indexed account, uint256 amount);

    function mint(address account, uint256 amount) external;

    function burn(address account, uint256 amount) external;
}
