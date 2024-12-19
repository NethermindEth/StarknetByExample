// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IMintableToken.sol";
import "starknet/IStarknetMessaging.sol";

/**
 * @title Contract to bridge tokens to and from Starknet. Has basic access control
 * with the `governor` being the only one able to set other storage variables.
 */
contract TokenBridge {
    address public governor;
    IMintableToken public token;
    IStarknetMessaging public snMessaging;
    uint256 public l2Bridge;
    // In our case the value for the `handle_deposit` method on Starknet will be:
    // `0x2D757788A8D8D6F21D1CD40BCE38A8222D70654214E96FF95D8086E684FBEE5`
    uint256 public l2HandlerSelector;

    /**
     * @dev The amount is zero.
     */
    error InvalidAmount();

    /**
     * @dev The address is invalid (e.g. `address(0)`).
     */
    error InvalidAddress(string);

    /**
     * @dev The Starknet address is invalid (e.g. `0`).
     */
    error InvalidRecipient();

    /**
     * @dev The L2 handler selector on Starknet is invalid (e.g. `0`).
     */
    error InvalidSelector();

    /**
     * @dev The sender is not the governor.
     */
    error OnlyGovernor();

    /**
     * @dev The L2 bridge address is not set.
     */
    error UninitializedL2Bridge();

    /**
     * @dev The L1 token address is not set.
     */
    error UninitializedToken();

    event L2BridgeSet(uint256 l2Bridge);
    event TokenSet(address token);
    event SelectorSet(uint256 selector);

    /**
       @dev Constructor.

       @param _governor The address of the governor.
       @param _snMessaging The address of Starknet Core contract, responsible for messaging.
       @param _l2HandlerSelector The selector of Starknet contract's #[l1_handler], responsible handling the L1 bridge request.
       
       @notice To read how Starknet selectors are calculated, see docs:
       https://docs.starknet.io/architecture-and-concepts/cryptography/hash-functions/#starknet_keccak
    */
    constructor(
        address _governor,
        address _snMessaging,
        uint256 _l2HandlerSelector
    ) {
        if (_governor == address(0)) {
            revert InvalidAddress("_governor");
        }
        if (_snMessaging == address(0)) {
            revert InvalidAddress("_snMessaging");
        }
        if (_l2HandlerSelector == 0) {
            revert InvalidSelector();
        }
        governor = _governor;
        snMessaging = IStarknetMessaging(_snMessaging);
        l2HandlerSelector = _l2HandlerSelector;
    }

    /**
     * @dev Throws if the sender is not the governor.
     */
    modifier onlyGovernor() {
        if (governor != msg.sender) {
            revert OnlyGovernor();
        }
        _;
    }

    /**
     * @dev Throws if the L2 bridge address is not set.
     */
    modifier onlyWhenL2BridgeInitialized() {
        if (l2Bridge == 0) {
            revert UninitializedL2Bridge();
        }
        _;
    }

    /**
     * @dev Throws if the L2 bridge address is not set.
     */
    modifier onlyWhenTokenInitialized() {
        if (address(token) == address(0)) {
            revert UninitializedToken();
        }
        _;
    }

    /**
     * @dev Sets a new L2 (Starknet) bridge address.
     *
     * @param newL2Bridge New bridge address.
     */
    function setL2Bridge(uint256 newL2Bridge) external onlyGovernor {
        if (newL2Bridge == 0) {
            revert InvalidAddress("newL2Bridge");
        }
        l2Bridge = newL2Bridge;
        emit L2BridgeSet(newL2Bridge);
    }

    /**
     * @dev Sets a new L1 address for the bridge token.
     *
     * @param newToken New token address.
     */
    function setToken(address newToken) external onlyGovernor {
        if (newToken == address(0)) {
            revert InvalidAddress("newToken");
        }
        token = IMintableToken(newToken);
        emit TokenSet(newToken);
    }

    /**
     * @dev Sets a new Starknet contract's #[l1_handler] selector.
     *
     * @param newSelector New selector value.
     */
    function setL2HandlerSelector(uint256 newSelector) external onlyGovernor {
        if (newSelector == 0) {
            revert InvalidSelector();
        }
        l2HandlerSelector = newSelector;
        emit SelectorSet(newSelector);
    }

    /**
       @dev Bridges tokens to Starknet.

       @param recipientAddress The contract's address on starknet.
       @param amount Token amount to bridge.

       @notice Consider that Cairo only understands felts252.
       So the serialization on solidity must be adjusted. For instance, a uint256
       must be split into two uint128 parts, and Starknet will be able to 
       deserialize the low and high part as a single u256 value.
    */
    function bridgeToL2(
        uint256 recipientAddress,
        uint256 amount
    ) external payable onlyWhenL2BridgeInitialized onlyWhenTokenInitialized {
        if (recipientAddress == 0) {
            revert InvalidRecipient();
        }
        if (amount == 0) {
            revert InvalidAmount();
        }
        (uint128 low, uint128 high) = splitUint256(amount);
        uint256[] memory payload = new uint256[](3);
        payload[0] = recipientAddress;
        payload[1] = low;
        payload[2] = high;

        token.burn(msg.sender, amount);

        snMessaging.sendMessageToL2{value: msg.value}(
            l2Bridge,
            l2HandlerSelector,
            payload
        );
    }

    /**
       @dev Manually consumes the bridge token request that was received from L2.

       @param fromAddress L2 contract (account) that has sent the message.
       @param recipient account to withdraw to.
       @param low lower 128-bit half of the uint256.
       @param high higher 128-bit half of the uint256.

       @notice There's no need to validate any of the input parameters, because
       the message hash from "invalid" data simply won't be found by the
       StarknetMessaging contract.
    */
    function consumeWithdrawal(
        uint256 fromAddress,
        address recipient,
        uint128 low,
        uint128 high
    ) external onlyWhenTokenInitialized {
        // recreate payload
        uint256[] memory payload = new uint256[](3);
        payload[0] = uint256(uint160(recipient));
        payload[1] = uint256(low);
        payload[2] = uint256(high);

        // Will revert if the message is not consumable.
        snMessaging.consumeMessageFromL2(fromAddress, payload);

        // recreate amount from 128-bit halves
        uint256 amount = (uint256(high) << 128) | uint256(low);
        token.mint(recipient, amount);
    }

    /**
     * @dev Splits the 256-bit integer into 128-bit halves that can be
     * deserialized by Starknet as a single u256 value.
     *
     * @param value 256-bit integer value
     * @return low lower/rightmost 128 bits of the integer
     * @return high upper/leftmost 128 bits of the integer
     */
    function splitUint256(
        uint256 value
    ) private pure returns (uint128 low, uint128 high) {
        // Extract the lower 128 bits by masking with 128 ones (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
        low = uint128(value & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);

        // Extract the upper 128 bits by shifting right by 128 bits
        high = uint128(value >> 128);
    }
}
