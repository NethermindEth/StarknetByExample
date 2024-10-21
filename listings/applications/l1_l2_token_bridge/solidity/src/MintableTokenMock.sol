// SPDX-License-Identifier: MIT.
pragma solidity ^0.8.0;

import "./IMintableToken.sol";

contract MintableTokenMock is IMintableToken {
    function mint(address account, uint256 amount) external {
        emit Minted(account, amount);
    }

    function burn(address account, uint256 amount) external {
        emit Burned(account, amount);
    }
}
