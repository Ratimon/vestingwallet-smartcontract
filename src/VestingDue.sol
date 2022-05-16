// SPDX-License-Identifier: MIT
pragma solidity =0.8.13;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Initializable} from "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import {VestingWallet} from "@openzeppelin/contracts/finance/VestingWallet.sol";

contract VestingDue is Initializable, VestingWallet {
    uint256 private interval;

    constructor(
        address beneficiaryAddress,
        uint64 startTimestamp,
        uint64 durationSeconds,
        // address _tokenLocked,
        // IERC20 token_,
        uint256 intervalInteger
    )
        // uint256 totalLock
        VestingWallet(beneficiaryAddress, startTimestamp, durationSeconds)
    {
        require(
            block.timestamp < startTimestamp + durationSeconds,
            "TokenTimelock: release time is before current time"
        );

        // // IERC20(_tokenLocked).transferFrom(msg.sender, address(this), totalLock);

        // require(
        //     totalLock == IERC20(_tokenLocked).balanceOf(address(this)),
        //     "TokenTimelock: Token is not yet transfered"
        // );

        interval = intervalInteger;
    }

    function init(address _tokenLocked, uint256 totalLock)
        external
        initializer
    {
        IERC20(_tokenLocked).transferFrom(msg.sender, address(this), totalLock);

        require(
            totalLock == IERC20(_tokenLocked).balanceOf(address(this)),
            "TokenTimelock: Token is not yet transfered"
        );
    }

    // /**
    //  * @dev Amount of releasable token
    //  */
    // function releasableAmount(address token)
    //     public
    //     view
    //     virtual
    //     returns (uint256)
    // {
    //     uint256 releasable = vestedAmount(token, uint64(block.timestamp)) -
    //         released(token);
    //     return releasable;
    // }
}
