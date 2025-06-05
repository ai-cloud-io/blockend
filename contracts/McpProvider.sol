// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import '@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol';
import '@openzeppelin/contracts/token/ERC20/IERC20.sol';

event ProviderRegistered(address indexed provider, string indexed uri);
event ProviderDeregistered(address indexed provider, string indexed reason);

contract McpProvider {
    struct Provider {
        address providerAddress;
        string uri;
        string serviceName;
        uint256 stake; // current USDC balance (deposit + earnings)
        uint256 initialDeposit; // USDC value deposited at registration
    }

    mapping(string => Provider) private providers;

    AggregatorV3Interface public priceFeed;
    IERC20 public usdcToken;
    uint256 public constant USD_REGISTRATION_FEE = 100 * 10 ** 8; // 100 in 8 decimals

    constructor(address _priceFeed, address _usdcToken) {
        priceFeed = AggregatorV3Interface(_priceFeed);
        usdcToken = IERC20(_usdcToken);
    }

    function getUsdcToUsd(uint256 usdAmount) public view returns (uint256) {
        (, int256 price, , , ) = priceFeed.latestRoundData(); // USDC/USD price in 8 decimals
        // Safeguard to ensure value is non-zero
        require(price > 0, 'Invalid Oracle Data');
        return (usdAmount * 10 ** 6) / uint256(price); // USDC has 6 decimals
    }

    function registerProvider(
        string memory uri,
        string memory serviceName
    ) public {
        // 1 uri cannot have multiple providers
        require(
            providers[uri].providerAddress == address(0),
            'Already registered'
        );
        uint256 usdcAmount = getUsdcToUsd(USD_REGISTRATION_FEE);
        // Transfer USDC from sender
        bool success = usdcToken.transferFrom(
            msg.sender,
            address(this),
            usdcAmount
        );
        require(success, 'USDC transfer failed');
        providers[uri] = Provider(
            msg.sender,
            uri,
            serviceName,
            usdcAmount,
            usdcAmount
        );
        emit ProviderRegistered(msg.sender, uri);
    }

    function getProvider(
        string memory _uri
    ) public view returns (address, string memory) {
        Provider memory p = providers[_uri];
        return (p.providerAddress, p.uri);
    }

    function getStake(string memory uri) public view returns (uint256) {
        return providers[uri].stake;
    }

    function getWithdrawableEarnings(
        string memory uri
    ) public view returns (uint256) {
        Provider memory p = providers[uri];
        if (p.stake > p.initialDeposit) {
            return p.stake - p.initialDeposit;
        } else {
            return 0;
        }
    }

    function deregisterProvider(string memory uri) public {
        require(providers[uri].providerAddress != address(0), 'Not registered');
        require(providers[uri].providerAddress == msg.sender, 'Unauthorized');
        uint256 refundAmount = providers[uri].stake;
        delete providers[uri];
        bool success = usdcToken.transfer(msg.sender, refundAmount);
        require(success, 'Refund failed');
        emit ProviderDeregistered(msg.sender, uri);
    }
}
