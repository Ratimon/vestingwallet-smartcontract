// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {DSTest} from "@ds-test/test.sol";
import {Vm} from "@forge-std/Vm.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {MockERC20, ERC20} from "@solmate/test/utils/mocks/MockERC20.sol";

import {VestingDue} from "../src/VestingDue.sol";

contract VestingDueTest is DSTest {
    Vm vm = Vm(HEVM_ADDRESS);

    address alice = address(0x1337);
    address bob = address(0x133702);

    MockERC20 token;
    VestingDue vestingdue;

    function setUp() public {
        vm.label(alice, "Alice");
        vm.label(bob, "Bob");
        vm.label(address(this), "TestVestingDue");

        token = new MockERC20("TestToken", "TT0", 18);
        vm.label(address(token), "TestToken");

        vestingdue = new VestingDue(alice, 1672506000, 365 days, 12);
        token.mint(bob, 12000 ether);

        vm.startPrank(bob);
        IERC20(address(token)).approve(address(vestingdue), 12000 ether);
        vestingdue.init(address(token), 12000 ether);
        vm.stopPrank();
    }

    function test_ConstructNonZeroTokenRevert() public {
        // vm.expectRevert(VestingDue.TokenAddressCannotBeZero.selector);
        vm.expectRevert(
            bytes("TokenTimelock: release time is before current time")
        );

        // 1672506000    // Date and time (GMT): Saturday, December 31, 2022 5:00:00 PM
        // 1804042000    // Date and time (GMT): Thursday, December 31, 2026 5:00:00 PM
        // 1704042000    // Date and time (GMT): Sunday, December 31, 2023 5:00:00 PM
        vm.warp(1804042000);

        new VestingDue(alice, 1672506000, 365 days, 12);
    }
}
