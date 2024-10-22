// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import "../src/TokenBridge.sol";
import "../src/MintableTokenMock.sol";
import "../src/StarknetMessagingLocal.sol";
import "../src/IStarknetMessagingEvents.sol";
import "../src/IMintableTokenEvents.sol";

contract TokenBridgeTest is
    Test,
    IStarknetMessagingEvents,
    IMintableTokenEvents
{
    address constant L2_BRIDGE_ADDRESS = address(uint160(0x543d));
    TokenBridge tokenBridge;
    MintableTokenMock mintableTokenMock;
    StarknetMessagingLocal snMessaging;

    function setUp() public {
        snMessaging = new StarknetMessagingLocal();
        mintableTokenMock = new MintableTokenMock();
        tokenBridge = new TokenBridge(
            address(snMessaging),
            L2_BRIDGE_ADDRESS,
            address(mintableTokenMock)
        );
    }

    function test_bridgeToL2() public {
        uint256 msgValue = 1000;
        uint256 recipientAddress = 123;
        uint256 amount = 1000;
        uint256[] memory expectedPayload = new uint256[](2);
        expectedPayload[0] = recipientAddress;
        expectedPayload[1] = amount;

        vm.expectEmit(true, false, false, true, address(mintableTokenMock));
        // The event we expect
        emit Burned(address(this), amount);

        vm.expectEmit(true, true, true, true, address(snMessaging));
        // The event we expect
        emit LogMessageToL2(
            address(tokenBridge),
            uint256(uint160(L2_BRIDGE_ADDRESS)),
            tokenBridge.L2_HANDLE_DEPOSIT_SELECTOR(),
            expectedPayload,
            0,
            msgValue
        );

        tokenBridge.bridgeToL2{value: msgValue}(recipientAddress, amount);
    }

    function test_consumeWithdrawal() public {
        uint256 fromAddress = uint256(uint160(L2_BRIDGE_ADDRESS));
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
        emit Minted(address(this), amount);

        tokenBridge.consumeWithdrawal(fromAddress, recipient, low, high);
    }
}
