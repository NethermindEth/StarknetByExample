// SPDX-License-Identifier: MIT.
pragma solidity ^0.8.0;

import "./IMintableTokenEvents.sol";

interface IMintableToken is IMintableTokenEvents {
    function mint(address account, uint256 amount) external;

    function burn(address account, uint256 amount) external;
}
