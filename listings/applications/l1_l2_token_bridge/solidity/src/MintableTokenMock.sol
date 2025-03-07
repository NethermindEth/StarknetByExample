// SPDX-License-Identifier: MIT.
pragma solidity ^0.8.0;

import "./IMintableToken.sol";

contract MintableTokenMock is IMintableToken {
    address public bridge;

    /**
     * @dev The address is invalid (e.g. `address(0)`).
     */
    error InvalidAddress();

    /**
     * @dev The sender is not the bridge.
     */
    error Unauthorized();

    /**
       @dev Constructor.

       @param _bridge The address of the L1 bridge.
    */
    constructor(address _bridge) {
        if (_bridge == address(0)) {
            revert InvalidAddress();
        }
        bridge = _bridge;
    }

    /**
     * @dev Throws if the sender is not the bridge.
     */
    modifier onlyBridge() {
        if (bridge != msg.sender) {
            revert Unauthorized();
        }
        _;
    }

    function mint(address account, uint256 amount) external onlyBridge {
        emit Minted(account, amount);
    }

    function burn(address account, uint256 amount) external onlyBridge {
        emit Burned(account, amount);
    }
}
