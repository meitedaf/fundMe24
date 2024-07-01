// SPDX-License-Identifier: MIT
//fund
//withdraw

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "../lib/foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";

contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 0.01 ether;

    function fundFundMe(address mostRecentlyDeploy) public {
        FundMe(payable(mostRecentlyDeploy)).fund{value: SEND_VALUE}();
        console.log("Funded FundMe with %u", SEND_VALUE);
    }

    function run() external {
        address mostRecentlyDeploy = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        vm.startBroadcast();
        fundFundMe(mostRecentlyDeploy);
        vm.stopBroadcast();
    }
}

contract WithdrawFundMe is Script {
    uint256 constant SEND_VALUE = 0.01 ether;

    function withdrawFundMe(address mostRecentlyDeploy) public {
        FundMe(payable(mostRecentlyDeploy)).withdraw();
    }

    function run() external {
        address mostRecentlyDeploy = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        vm.startBroadcast();
        withdrawFundMe(mostRecentlyDeploy);
        vm.stopBroadcast();
    }
}
