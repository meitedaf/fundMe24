// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe} from "../../script/Interactions.s.sol";

contract InteractionsTest is Test {
    FundMe fundMe;
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.01 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        DeployFundMe deploy = new DeployFundMe();
        fundMe = deploy.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testUserCanFund() public {
        //arrange
        FundFundMe contractFundFundMe = new FundFundMe();
        uint256 startUserBalance = USER.balance;
        uint256 startFundMeBalance = address(fundMe).balance;
        //act
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        //assert
        uint256 endingUserBalance = USER.balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assert(endingUserBalance == startUserBalance - SEND_VALUE);
        assertEq(endingFundMeBalance, startFundMeBalance + SEND_VALUE);
    }
}
