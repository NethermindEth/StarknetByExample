// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import "starknet/IStarknetMessagingEvents.sol";

import "../src/TokenBridge.sol";
import "../src/MintableTokenMock.sol";
import "../src/StarknetMessagingLocal.sol";
import "../src/IMintableTokenEvents.sol";

contract TokenBridgeTest is
    Test,
    IStarknetMessagingEvents,
    IMintableTokenEvents
{
    TokenBridge tokenBridge;
    MintableTokenMock mintableTokenMock;
    StarknetMessagingLocal snMessaging;

    uint256 constant L2_BRIDGE_ADDRESS = 0x543d;
    uint256 constant L2_HANDLER_SELECTOR =
        0x2D757788A8D8D6F21D1CD40BCE38A8222D70654214E96FF95D8086E684FBEE5;

    function setUp() public {
        snMessaging = new StarknetMessagingLocal();
        tokenBridge = new TokenBridge(
            address(this),
            address(snMessaging),
            L2_HANDLER_SELECTOR
        );
        mintableTokenMock = new MintableTokenMock(address(tokenBridge));

        tokenBridge.setL2Bridge(L2_BRIDGE_ADDRESS);
        tokenBridge.setToken(address(mintableTokenMock));
    }

    function test_bridgeToL2() public {
        uint256 msgValue = 1000;
        uint256 recipientAddress = 123;
        uint256 amount = 1000;
        uint256[] memory expectedPayload = new uint256[](3);
        expectedPayload[0] = recipientAddress;
        expectedPayload[1] = amount; // low
        expectedPayload[2] = 0; // high

        vm.expectEmit(true, false, false, true, address(mintableTokenMock));
        // The event we expect
        emit Burned(address(this), amount);

        vm.expectEmit(true, true, true, true, address(snMessaging));
        // The event we expect
        emit LogMessageToL2(
            address(tokenBridge),
            L2_BRIDGE_ADDRESS,
            tokenBridge.l2HandlerSelector(),
            expectedPayload,
            0,
            msgValue
        );

        tokenBridge.bridgeToL2{value: msgValue}(recipientAddress, amount);
    }

    function test_consumeWithdrawal() public {
        uint256 fromAddress = L2_BRIDGE_ADDRESS;
        address recipient = address(0x123);
        uint128 low = 1000;
        uint128 high = 0;
        uint256 amount = low;
        uint256[] memory expectedPayload = new uint256[](3);
        expectedPayload[0] = uint256(uint160(recipient));
        expectedPayload[1] = uint256(low);
        expectedPayload[2] = uint256(high);

        uint256[] memory msgHashes = new uint256[](1);
        msgHashes[0] = uint256(
            keccak256(
                abi.encodePacked(
                    fromAddress,
                    uint256(uint160(address(tokenBridge))),
                    expectedPayload.length,
                    expectedPayload
                )
            )
        );
        snMessaging.addMessageHashesFromL2(msgHashes);

        vm.expectEmit(true, true, true, true, address(snMessaging));
        // The event we expect
        emit ConsumedMessageToL1(
            fromAddress,
            address(tokenBridge),
            expectedPayload
        );

        vm.expectEmit(true, false, false, true, address(mintableTokenMock));
        // The event we expect
        emit Minted(recipient, amount);

        tokenBridge.consumeWithdrawal(fromAddress, recipient, low, high);
    }
}
