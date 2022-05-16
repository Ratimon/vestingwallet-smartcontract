// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {DSTest} from "@ds-test/test.sol";
// import "@forge-std/Test.sol";
import {Vm} from "@forge-std/Vm.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {MockERC20, ERC20} from "@solmate/test/utils/mocks/MockERC20.sol";

import {VestingDue} from "../src/VestingDue.sol";

// contract TokenReturner {
//     uint256 return_amount;

//     function receiveTokens(
//         address tokenAddress,
//         uint256 /* amount */
//     ) external {
//         // all we do is transfer the return_amount back :)
//         ERC20(tokenAddress).transfer(msg.sender, return_amount);
//     }
// }

contract VestingDueTest is DSTest {
    // contract VestingDueTest is DSTest, TokenReturner {
    Vm vm = Vm(HEVM_ADDRESS);

    address alice = address(0x1337);
    address bob = address(0x133702);

    MockERC20 token;
    VestingDue vestingdue;

    // let currentTimestamp = 1672506000 // Date and time (GMT): Saturday, December 31, 2022 5:00:00 PM

    function setUp() public {
        vm.label(alice, "Alice");
        vm.label(bob, "Bob");
        vm.label(address(this), "TestVestingDue");

        token = new MockERC20("TestToken", "TT0", 18);
        vm.label(address(token), "TestToken");

        vestingdue = new VestingDue(
            alice,
            1672506000,
            365 days,
            // address(token),
            12
            // 12000 ether
        );

        token.mint(bob, 12000 ether);

        vm.startPrank(bob);
        IERC20(address(token)).approve(address(vestingdue), 12000 ether);

        vestingdue.init(address(token), 12000 ether);
        vm.stopPrank();
    }

    // function testExample() public {
    //     assertTrue(true);
    // }

    function test_ConstructNonZeroTokenRevert() public {
        // vm.expectRevert(VestingDue.TokenAddressCannotBeZero.selector);
        vm.expectRevert(
            bytes("TokenTimelock: release time is before current time")
        );

        // 1672506000
        // 1704042000         // Date and time (GMT): Sunday, December 31, 2023 5:00:00 PM
        vm.warp(1804042000);

        new VestingDue(
            alice,
            1672506000,
            365 days,
            // address(token),
            12
            // 12000 ether
        );
    }
}
