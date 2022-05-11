// SPDX-License-Identifier: MIT
pragma solidity =0.8.13;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {VestingWallet} from "@openzeppelin/contracts/finance/VestingWallet.sol";

contract VestingDue is VestingWallet {
    constructor(
        address beneficiaryAddress,
        uint64 startTimestamp,
        uint64 durationSeconds,
        IERC20 token_,
        uint256 intervalInteger,
        uint256 totalLock
    ) VestingWallet(beneficiaryAddress, startTimestamp, durationSeconds) {}
}
