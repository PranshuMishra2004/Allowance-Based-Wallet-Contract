// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

contract AllowanceWallet{

    address public owner;

    mapping(address=>uint256) public allowance;    // map for variable allowance

    constructor(){                                 // constructor for owner
        owner=msg.sender;
    }

    modifier onlyowner(){                           // modifier is used to make it safe and allows code reuse
        require(msg.sender==owner,"Invalid User");
        _;                                           // it represents the function executes here after require is completed
    }

    function deposit() public payable {              // deposit function , using payable is must without it we can not deposit
        require(msg.value>0,"Send Some ETH");
    }

    function setAllowance(address _user,uint256 _owner) public onlyowner{     // set allowance so that not anyone can access it and also have a limiter to the money
        allowance[_user]=_owner;
    }

    function withdrawal(uint256 _amount) public {          // withdraw fuunction
        require(_amount>0,"Amount must>0");

            if(msg.sender != owner){                        // if condition to check balance and allowance
                require(allowance[msg.sender]>=_amount,"Low Balance");
                allowance[msg.sender]-= _amount;
            }

            (bool success, )= payable(msg.sender).call{value: _amount}("");  // transfer money using call
            require(success,"ETH Transfer fail");

    }

    function returnBalance() public view returns(uint256){      // return remaining balance 
        return address(this).balance;
    }

}