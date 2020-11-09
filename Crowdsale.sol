pragma solidity ^0.5.0;

import "./PupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

// Inherit the crowdsale contracts
contract PupperCoinSale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundablePostDeliveryCrowdsale {

    constructor(
        // Crowdsale openzeppelin constructor params
        uint256 rate,
        address payable wallet,
        PupperCoin token,
        
        // CappedCrowdsale constructor param
        uint256 goal,
        
        // TimedCrowsale params
        uint256 openingTime,
        uint256 closingTime
        
    )
        // Pass the constructor parameters to the crowdsale contracts.
        Crowdsale(rate, wallet, token) 
        CappedCrowdsale(goal) 
        TimedCrowdsale(openingTime, closingTime) 
        RefundableCrowdsale(goal) 
        public
    {
        // constructor stays empty
    }
}

contract PupperCoinSaleDeployer {

    address public tokenSaleAddress;
    address public tokenAddress;

    constructor(
        // constructor parameters
        string memory name,
        string memory symbol,
        address payable wallet,
        uint256 goal
    )
        public
    {
        // create the PupperCoin and keep its address handy
        PupperCoin token = new PupperCoin(name, symbol, 0);
        tokenAddress = address(token);

        // @TODO: create the PupperCoinSale and tell it about the token, set the goal, and set the open and close times to now and now + 24 weeks.
        PupperCoinSale tokenSale = new PupperCoinSale(1, wallet, token, goal, now, now + 24 weeks);
        tokenSaleAddress = address(tokenSale);

        // make the PupperCoinSale contract a minter, then have the PupperCoinSaleDeployer renounce its minter role
        token.addMinter(tokenSaleAddress);
        token.renounceMinter();
    }
}
