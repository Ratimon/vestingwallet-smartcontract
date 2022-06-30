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

    // 1672506000    // Date and time (GMT): Saturday, December 31, 2022 5:00:00 PM
    uint64 startTime = 1672506000;
    uint64 duration = 365 days;
    uint256 interval = 12;
    uint256 vestingAmount = 12000 ether;

    MockERC20 token;
    VestingDue vestingdue;

    function setUp() public {
        vm.label(alice, "Alice");
        vm.label(bob, "Bob");
        vm.label(address(this), "TestVestingDue");

        token = new MockERC20("TestToken", "TT0", 18);
        vm.label(address(token), "TestToken");

        // 1672506000    // Date and time (GMT): Saturday, December 31, 2022 5:00:00 PM
        vestingdue = new VestingDue(alice, startTime, duration, interval);
        token.mint(bob, vestingAmount);

        vm.startPrank(bob);
        IERC20(address(token)).approve(address(vestingdue), vestingAmount);
        vestingdue.init(address(token), vestingAmount);
        vm.stopPrank();
    }

    // function testFuzz_Release(uint256 releasingAmount) public {
    //     // vm.assume(type(uint256).max - releasingAmount >= token.totalSupply());
    //     // vm.assume(amount > 0);
    //     //
    //     //
    // }

    // test by release begining of the month every month

    // function testFuzz_Release(uint256 timeInSeconds) public {
    //     // vm.assume(type(uint256).max - releasingAmount >= token.totalSupply());
    //     vm.assume(3 days >= timeInSeconds);
    //     vm.assume(timeInSeconds > 0);
    //     //
    //     //
    // }

    // test by release begining of the month every month

    // function test_InitNonZeroTokenRevert() public {
    //     vm.expectRevert(VestingDue.AmountCannotBeZero.selector);
    //     vestingdue.init(address(token), 0);
    // }

    // function test_InitTokenTransferedNotEqualRevert() public {
    //     token.mint(bob, 14000 ether);

    //     vm.startPrank(bob);

    //     IERC20(address(token)).approve(address(vestingdue), 12000 ether);
    //     IERC20(address(token)).transfer(address(vestingdue), 2000 ether);

    //     vm.expectRevert(
    //         bytes("VestingDue: Tokens transfered != actual balance")
    //     );
    //     vestingdue.init(address(token), 12000);
    //     vm.stopPrank();
    // }
}
