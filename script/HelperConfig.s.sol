// SPDX-License-Identifier: MIT

//Deploy mocks when we are on a local anvil chain
//Keep track of different address acoss different chain
//Sepolia ETH/USD
//Mainnet ETH/USD

pragma solidity ^0.8.18;
import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 3000e8;
    NetworkConfig public activeNetworkConfig;
    //If we are on a local chain, we deploy mocks
    //Otherwise, grab the existing address from the live network
    struct NetworkConfig {
        address priceFeed;
    }

    constructor() {
        if (block.chainid == 11155111)
            activeNetworkConfig = getSepoliaEthConfig();
        else if (block.chainid == 1)
            activeNetworkConfig = getMainnetEthConfig();
        else activeNetworkConfig = getOrCreateAnvilEthConfig();
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory spoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return spoliaConfig;
    }

    function getMainnetEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory mainnetConfig = NetworkConfig(
            0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        );
        return mainnetConfig;
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        //if the mock is deployed
        if (activeNetworkConfig.priceFeed != address(0))
            return activeNetworkConfig;
        //1. Depoly the mocks
        //2. Return the mock adresses
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            DECIMALS,
            INITIAL_PRICE
        );
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });
        return anvilConfig;
    }
}
