/**
 * Submitted for verification at ...
*/

pragma solidity ^0.8.15;

import './libs/context.sol';
import './libs/ownable.sol';
import './libs/address.sol';
import './libs/SafeERC20.sol';

//SPDX-License-Identifier: Unlicense

pragma solidity 0.8.15;

///@title Vesting contract
///@notice Allows linear vesting of Vorpal tokens after a timelock
///@notice The address can have only one vesting schedule

contract PermanentSale is Ownable {
    using SafeERC20 for IERC20;

    IERC20 public paymentToken;
    IERC20 public saleToken;
    uint256 public price;
    // address internal ctrct = address(this);

    constructor(
        IERC20 _paymentToken,
        IERC20 _saleToken,
        uint256 _price
    ) {
        paymentToken = _paymentToken;
        saleToken = _saleToken;
        price = _price;
    }

    function GetAvailableAmount () public view returns (uint256) {
        return saleToken.balanceOf(address(this));
    }

    function UpdatePrice (uint256 _newPrice) external onlyOwner {
        price = _newPrice;
    }

    function WithdrawUnsoldToken (address to) external onlyOwner {
        uint256 remainingBalance = GetAvailableAmount ();
        saleToken.safeTransfer(to, remainingBalance);
    }

    function WithdrawPaymentToken (address to) external onlyOwner {
        uint256 revenue = paymentToken.balanceOf(address(this));
        paymentToken.safeTransfer(to, revenue);
    }

    function BuyTokens (uint256 _amountPayment) external {
        if (_amountPayment < 1e18) {
            revert("Insufficient balance");
        }

        uint256 buyingAmount = (_amountPayment / price) * 1e18;
        uint256 _available = GetAvailableAmount ();

        if (_available < buyingAmount) {
            revert("Insufficient available tokens");
        }

        paymentToken.safeTransferFrom(msg.sender, address(this), _amountPayment);
        saleToken.safeTransfer(msg.sender, buyingAmount);

    }

}