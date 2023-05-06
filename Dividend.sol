pragma solidity ^0.8.15;

import './libs/context.sol';
import './libs/ownable.sol';
import './libs/address.sol';
import './libs/SafeERC20.sol';

//SPDX-License-Identifier: Unlicense

contract ChainScalesDividendManager is Ownable {

    using SafeERC20 for IERC20;
    IERC20 public token;

    constructor(
        IERC20 _token
    ) {
       token = _token;
    }

    mapping(address => uint) balances;
    
    function EnterStaking (uint amount) external {
  
    }

    function WithdrawStaking (uint amount) external {
        
    }

    function PayDividend () external onlyOwner {

    }

    function GetTokenBalance (address _owner) external view returns (uint) {
        return 1;
    }

}