pragma solidity ^0.8.15;

import './libs/context.sol';
import './libs/ownable.sol';
import './libs/address.sol';
import './libs/SafeERC20.sol';

//SPDX-License-Identifier: Unlicense

contract ChainScalesDividendManager is Ownable {

    using SafeERC20 for IERC20;
    IERC20 public token;
    uint256 public totalTokenBalance;

    constructor(
        IERC20 _token
    ) {
       token = _token;
    }

    mapping(address => uint) balances;
    
    function EnterStaking (uint256 amount) external {
        token.safeTransferFrom(msg.sender, address(this), amount);
        balances[msg.sender] += amount;
        totalTokenBalance += amount;
    } 

    function WithdrawStaking (uint amount) external {
        if (balances[msg.sender] < amount) {
            revert("User balance is smaller than requesting amount");
        }

        token.safeTransfer(msg.sender, amount);
        balances[msg.sender] -= amount;
        totalTokenBalance -= amount;
    }

    function PayDividend () external onlyOwner {
        if (totalTokenBalance == 0) {
            revert("Nobody enter any amount to staking");
        }
    }

    function GetTokenBalance (address _owner) external view returns (uint) {
        return balances[_owner];
    }

}