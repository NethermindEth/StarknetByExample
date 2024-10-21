// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IMintableToken.sol";
import "./IStarknetMessaging.sol";

// Define some custom error as an example.
// It saves a lot's of space to use those custom error instead of strings.
error InvalidPayload();

/**
   @title Test contract to receive / send messages to starknet.
*/
contract TokenBridge {
    IMintableToken private _mintableToken;
    IStarknetMessaging private _snMessaging;
    uint256 private _l2Bridge;

    uint256 constant L2_HANDLE_DEPOSIT_SELECTOR =
        0x2D757788A8D8D6F21D1CD40BCE38A8222D70654214E96FF95D8086E684FBEE5;

    /**
       @notice Constructor.

       @param snMessaging The address of Starknet Core contract, responsible for messaging.
       @param l2Bridge The address of Starknet bridge contract.
       @param token The address of token to be briged.
    */
    constructor(address snMessaging, address l2Bridge, address token) {
        _snMessaging = IStarknetMessaging(snMessaging);
        _mintableToken = IMintableToken(token);
        _l2Bridge = uint256(uint160(l2Bridge));
    }

    /**
       @notice Sends a message to Starknet contract.

       @param recipientAddress The contract's address on starknet.
       @param amount The l1_handler function of the contract to call.

       @dev Consider that Cairo only understands felts252.
       So the serialization on solidity must be adjusted. For instance, a uint256
       must be split in two uint256 with low and high part to be understood by Cairo.
    */
    function initiate_withdraw(
        uint256 recipientAddress,
        uint256 amount
    ) external payable {
        uint256[] memory payload = new uint256[](1);
        payload[0] = recipientAddress;
        payload[1] = amount;

        _snMessaging.sendMessageToL2{value: msg.value}(
            _l2Bridge,
            L2_HANDLE_DEPOSIT_SELECTOR,
            payload
        );
    }

    /**
       @notice Manually consumes a message that was received from L2.

       @param fromAddress L2 contract (account) that has sent the message.
       @param payload Payload of the message used to verify the hash.

       @dev A message "receive" means that the message hash is registered as consumable.
       One must provide the message content, to let Starknet Core contract verify the hash
       and validate the message content before being consumed.
    */
    function consumeMessage(
        uint256 fromAddress,
        uint256[] calldata payload
    ) external {
        // Will revert if the message is not consumable.
        _snMessaging.consumeMessageFromL2(fromAddress, payload);

        // We expect the payload to contain field `a` and `b` from `MyData`.
        if (payload.length != 3) {
            revert InvalidPayload();
        }

        address recipient = address(uint160(payload[0]));
        uint128 low = uint128(payload[1]);
        uint128 high = uint128(payload[2]);
    }
}
