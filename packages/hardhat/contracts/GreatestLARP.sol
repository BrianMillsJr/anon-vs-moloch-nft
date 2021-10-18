//SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "./TokenRecover.sol";

interface BotToken {
    function lastMintedToken() external view returns (uint256);

    function mint(address user) external returns (uint256);
}

interface StatueToken {
    function lastMintedToken() external view returns (uint256);

    function mint(address user) external returns (uint256);
}

/// @title GreatestLARP Factory Contract
/// @author jaxcoder, ghostffcode
/// @notice
/// @dev
contract GreatestLARP is Ownable {
    using SafeMath for uint256;
    address payable immutable gitcoin;

    struct Token {
        address tokenAddress;
        uint256 thresholdBots;
        uint256 thresholdStatues;
        uint256 price;
        uint256 inflationRate;
        uint256 totalSupply;
    }

    mapping(uint256 => Token) tokenMap;
    mapping(uint256 => Token) statueMap;

    uint256 public totalTokens;
    uint256 public totalStatues;

    modifier isValidLevel(uint256 level) {
        // level is between 1 and totalTokens Count
        require(level > 0, "Invalid level selected");
        require(level <= totalTokens, "Invalid level selected");
        require(level <= totalStatues, "Invalid level selected");
        _;
    }

    constructor(
        BotToken[] memory tokens,
        StatueToken[] memory statueTokens,
        uint256[] memory thresholdBots,
        uint256[] memory thresholdStatues,
        uint256 startPriceBot,
        uint256 startPriceStatue,
        uint256[] memory inflationRatesStatues,
        uint256[] memory inflationRatesBots
    ) {
        gitcoin = payable(address(0xde21F729137C5Af1b01d73aF1dC21eFfa2B8a0d6));

        require(
            tokens.length == thresholdBots.length,
            "Mismatch length of tokens and threshold"
        );

        require(
            statueTokens.length == thresholdStatues.length,
            "Mismatch length of tokens and threshold"
        );


        for (uint256 i = 0; i < tokens.length; i++) {
            // increment tokens count
            totalTokens += 1;

            // add token to tokenMap
            tokenMap[totalTokens] = Token({
                tokenAddress: address(tokens[i]),
                thresholdBots: thresholdBots[i],
                thresholdStatues: 0,
                price: startPriceBot,
                totalSupply: 300,
                inflationRate: inflationRatesBots[i]
            });
        }

        for (uint256 i = 0; i < statueTokens.length; i++) {
            // increment tokens count
            totalStatues += 1;

            // add token to tokenMap
            statueMap[totalStatues] = Token({
                tokenAddress: address(statueTokens[i]),
                thresholdBots: 0,
                thresholdStatues: thresholdStatues[i],
                price: startPriceStatue,
                totalSupply: 5,
                inflationRate: inflationRatesStatues[i]
            });
        }
    }

    /// @dev A function that can be called from Etherscan to lower
    ///      the price of the item by 10%.
    function whompwhomp(uint256 _level) public isValidLevel(_level) onlyOwner {
        tokenMap[_level].price = tokenMap[_level].price.sub(
            tokenMap[_level].price.mul(10).div(100)
        );
        statueMap[_level].price = statueMap[_level].price.sub(
            statueMap[_level].price.mul(10).div(100)
        );
    }

    function getDetailForTokenLevels()
        public
        view
        returns (uint256[5][] memory)
    {
        uint256[5][] memory levels = new uint256[5][](totalTokens);

        for (uint256 i = 1; i <= totalTokens; i++) {
            uint256[5] memory levelInfo;
            levelInfo[0] = tokenMap[i].price;
            levelInfo[1] = tokenMap[i].thresholdBots;
            levelInfo[2] = tokenMap[i].totalSupply;
            levelInfo[3] = BotToken(tokenMap[i].tokenAddress).lastMintedToken();
            levelInfo[4] = tokenMap[i].totalSupply - levelInfo[3];

            // push levelInfo into levels
            levels[i - 1] = levelInfo;
        }

        return levels;
    }

    function getDetailForStatueLevels()
        public
        view
        returns (uint256[5][] memory)
    {
        uint256[5][] memory levels = new uint256[5][](totalTokens);

        for (uint256 i = 1; i <= totalStatues; i++) {
            uint256[5] memory levelInfo;
            levelInfo[0] = statueMap[i].price;
            levelInfo[1] = statueMap[i].thresholdStatues;
            levelInfo[2] = statueMap[i].totalSupply;
            levelInfo[3] = BotToken(statueMap[i].tokenAddress)
                .lastMintedToken();
            levelInfo[4] = statueMap[i].totalSupply - levelInfo[3];

            // push levelInfo into levels
            levels[i - 1] = levelInfo;
        }

        return levels;
    }

    /// @dev request to mint a Bot NFT
    function requestMint(uint256 level)
        public
        payable
        isValidLevel(level)
        returns (uint256)
    {
        BotToken levelToken = BotToken(tokenMap[level].tokenAddress);

        // check if threshold for previous token has been reached
        if (level > 1) {
            uint256 previousLevel = level - 1;
            require(
                BotToken(tokenMap[previousLevel].tokenAddress)
                    .lastMintedToken() >= tokenMap[previousLevel].thresholdBots,
                "You can't continue until the previous level threshold is reached"
            );
        }

        // compare value and price
        require(msg.value >= tokenMap[level].price, "NOT ENOUGH");

        // store the old price
        uint256 currentPrice = tokenMap[level].price;

        // update the price of the token
        tokenMap[level].price = (currentPrice * tokenMap[level].inflationRate) / 1000;

        // make sure there are available tokens for this level
        require(
            levelToken.lastMintedToken() <= tokenMap[level].totalSupply,
            "Minting completed for this level"
        );

        // mint token
        uint256 id = levelToken.mint(msg.sender);

        // send ETH to gitcoin multisig
        (bool success, ) = gitcoin.call{value: currentPrice}("");
        require(success, "could not send");

        // send the refund
        uint256 refund = msg.value.sub(currentPrice);
        if (refund > 0) {
            (bool refundSent, ) = msg.sender.call{value: refund}("");
            require(refundSent, "Refund could not be sent");
        }

        return id;
    }

    /// @dev request to mint a statue NFT
    function requestMintStatue(uint256 level)
        public
        payable
        isValidLevel(level)
        returns (uint256)
    {
        StatueToken levelToken = StatueToken(statueMap[level].tokenAddress);

        // check if threshold for previous token has been reached
        if (level > 1) {
            uint256 previousLevel = level - 1;
            require(
                StatueToken(statueMap[previousLevel].tokenAddress)
                    .lastMintedToken() >=
                    statueMap[previousLevel].thresholdStatues,
                "You can't continue until the previous level threshold is reached"
            );
        }

        // compare value and price
        require(msg.value >= statueMap[level].price, "NOT ENOUGH");

        // store the old price
        uint256 currentPrice = statueMap[level].price;

        // update the price of the token
        statueMap[level].price = (currentPrice * 1350) / 1000;

        // make sure there are available tokens for this level
        require(
            levelToken.lastMintedToken() <= statueMap[level].totalSupply,
            "Minting completed for this level"
        );

        // mint token
        uint256 id = levelToken.mint(msg.sender);

        // send ETH to gitcoin multisig
        (bool success, ) = gitcoin.call{value: currentPrice}("");
        require(success, "could not send");

        // send the refund
        uint256 refund = msg.value.sub(currentPrice);
        if (refund > 0) {
            (bool refundSent, ) = msg.sender.call{value: refund}("");
            require(refundSent, "Refund could not be sent");
        }

        return id;
    }
}
