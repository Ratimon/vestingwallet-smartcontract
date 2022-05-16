// SPDX-License-Identifier: MIT
pragma solidity =0.8.13;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Initializable} from "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import {SafeMath} from "@openzeppelin/contracts/utils/math/SafeMath.sol";
import {VestingWallet} from "@openzeppelin/contracts/finance/VestingWallet.sol";

contract VestingDue is Initializable, VestingWallet {
    using SafeMath for uint256;

    error AddressCannotBeZero();
    error AmountCannotBeZero();

    uint256 private _interval;
    uint64 private _duration;

    constructor(
        address beneficiaryAddress,
        uint64 startTimestamp,
        uint64 durationSeconds,
        uint256 intervalInteger
    ) VestingWallet(beneficiaryAddress, startTimestamp, durationSeconds) {
        // if (beneficiaryAddress == address(0)) revert AddressCannotBeZero();

        require(
            block.timestamp < startTimestamp + durationSeconds,
            "VestingDue: release time is before current time"
        );

        // require(intervalInteger != 0, "intervalInteger cannot be the zero");
        if (intervalInteger == 0) revert AmountCannotBeZero();

        _duration = durationSeconds;
        _interval = intervalInteger;
    }

    function init(address _tokenLocked, uint256 totalLock)
        external
        initializer
    {
        if (_tokenLocked == address(0)) revert AddressCannotBeZero();
        if (totalLock == 0) revert AmountCannotBeZero();

        IERC20(_tokenLocked).transferFrom(msg.sender, address(this), totalLock);

        require(
            totalLock == IERC20(_tokenLocked).balanceOf(address(this)),
            "VestingDue: Tokens transfered != actual balance"
        );
    }

    function interval() public view virtual returns (uint256) {
        return _interval;
    }

    function releasableAmount(address token)
        public
        view
        virtual
        returns (uint256)
    {
        uint256 releasable = vestedAmount(token, uint64(block.timestamp)) -
            released(token);
        return releasable;
    }

    function _vestingSchedule(uint256 totalAllocation, uint64 timestamp)
        internal
        view
        override
        returns (uint256)
    {
        //eg  months in epoch
        uint256 totalParts = duration().div(interval());
        // eg 10,000 per month
        uint256 allocationByPart = totalAllocation.div(interval());

        if (timestamp < start()) {
            // paid at the begining of the month
            return allocationByPart;
        } else if (timestamp > start() + duration()) {
            return totalAllocation;
        } else {
            // (0,1) => 0  (1,2) => 1 (9,10) => 9
            uint256 pastParts = (timestamp - start()).div(totalParts);

            //Truncuate to begining of the month
            // (0,1) => 1 (1,2) => 2 (9,10) => 10
            pastParts = pastParts += 1;

            return allocationByPart.mul(pastParts);
        }
    }
}
