// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IMintableToken.sol";
import "./IStarknetMessaging.sol";

error InvalidAddress(string);
error OnlyGovernor();
error UninitializedL2Bridge();

/**
   @title Test contract to receive / send messages to starknet.
*/
contract TokenBridge {
    event L2BridgeSet(uint256 l2Bridge);
    event TokenSet(address token);

    address public governor;
    IMintableToken public mintableToken;
    IStarknetMessaging public snMessaging;
    uint256 public l2Bridge;

    uint256 public constant L2_HANDLE_DEPOSIT_SELECTOR =
        0x2D757788A8D8D6F21D1CD40BCE38A8222D70654214E96FF95D8086E684FBEE5;

    /**
       @notice Constructor.

       @param _governor The address of the governor.
       @param _snMessaging The address of Starknet Core contract, responsible for messaging.
       @param _token The address of token to be briged.
    */
    constructor(address _governor, address _snMessaging, address _token) {
        if (_governor == address(0)) {
            revert InvalidAddress("_governor");
        }
        if (_snMessaging == address(0)) {
            revert InvalidAddress("_snMessaging");
        }
        if (_token == address(0)) {
            revert InvalidAddress("_token");
        }
        governor = _governor;
        snMessaging = IStarknetMessaging(_snMessaging);
        mintableToken = IMintableToken(_token);
    }

    modifier onlyGovernor() {
        if (governor != msg.sender) {
            revert OnlyGovernor();
        }
        _;
    }

    modifier onlyl2BridgeInitialized() {
        if (l2Bridge == 0) {
            revert UninitializedL2Bridge();
        }
        _;
    }

    function setL2Bridge(uint256 newL2Bridge) external onlyGovernor {
        if (newL2Bridge == 0) {
            revert InvalidAddress("newL2Bridge");
        }
        l2Bridge = newL2Bridge;
        emit L2BridgeSet(newL2Bridge);
    }

    function setToken(address newToken) external onlyGovernor {
        if (newToken == address(0)) {
            revert InvalidAddress("newToken");
        }
        mintableToken = IMintableToken(newToken);
        emit TokenSet(newToken);
    }

    /**
       @notice Sends a message to Starknet contract.

       @param recipientAddress The contract's address on starknet.
       @param amount The l1_handler function of the contract to call.

       @dev Consider that Cairo only understands felts252.
       So the serialization on solidity must be adjusted. For instance, a uint256
       must be split in two uint256 with low and high part to be understood by Cairo.
    */
    function bridgeToL2(
        uint256 recipientAddress,
        uint256 amount
    ) external payable onlyl2BridgeInitialized {
        (uint128 low, uint128 high) = splitUint256(amount);
        uint256[] memory payload = new uint256[](3);
        payload[0] = recipientAddress;
        payload[1] = low;
        payload[2] = high;

        mintableToken.burn(msg.sender, amount);

        snMessaging.sendMessageToL2{value: msg.value}(
            l2Bridge,
            L2_HANDLE_DEPOSIT_SELECTOR,
            payload
        );
    }

    /**
       @notice Manually consumes a message that was received from L2.

       @param fromAddress L2 contract (account) that has sent the message.
       @param recipient account to withdraw to.
       @param low lower half of the uint256.
       @param high higher half of the uint256.

       @dev A message "receive" means that the message hash is registered as consumable.
       One must provide the message content, to let Starknet Core contract verify the hash
       and validate the message content before being consumed.
    */
    function consumeWithdrawal(
        uint256 fromAddress,
        address recipient,
        uint128 low,
        uint128 high
    ) external {
        // recreate payload
        uint256[] memory payload = new uint256[](3);
        payload[0] = uint256(uint160(recipient));
        payload[1] = uint256(low);
        payload[2] = uint256(high);

        // Will revert if the message is not consumable.
        snMessaging.consumeMessageFromL2(fromAddress, payload);

        // recreate amount from 128-bit halves
        uint256 amount = (uint256(high) << 128) | uint256(low);
        mintableToken.mint(msg.sender, amount);
    }

    function splitUint256(
        uint256 value
    ) private pure returns (uint128 low, uint128 high) {
        // Extract the lower 128 bits by masking with 128 ones (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
        low = uint128(value & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);

        // Extract the upper 128 bits by shifting right by 128 bits
        high = uint128(value >> 128);
    }
}
