// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./InterfaceERC20.sol";
contract ERC20Token is InterfaceERC20{
        uint256 constant private MAX_UINT256= 2**256-1;

        mapping(address=>uint256) public balances;
        mapping(address=>mapping(address => uint256)) allowed;

        uint256 public totSupply;
        string public name;
        string public symbol;
        uint8  public decimals;

        constructor( uint256 _initialAmount, string memory _name,
                      uint8  _decimals, string memory _symbol) public{
            balances[msg.sender] = _initialAmount;
            totSupply = _initialAmount;
            name = _name;
            symbol = _symbol;
            decimals = _decimals;
        }

        function transfer(address _recipient, uint256 _amount) public returns (bool){
            require(balances[msg.sender] > _amount,"Insufficient funds fot transfer source!!");
            balances[_recipient] += _amount;
            balances[msg.sender] -= _amount;
            emit Transfer(msg.sender,_recipient, _amount);
            return true;
        }

        function transferFrom(
                        address _sender,
                        address _recipient,
                        uint256 _amount
        ) public returns (bool){
            uint256 allowanceLimit = allowed[_sender][msg.sender];
            require(balances[msg.sender]>_amount && allowanceLimit > _amount, "Insufficient allowed funds for transfer source.");
            balances[_recipient] += _amount;
            balances[_sender] -= _amount;
            if (allowanceLimit < MAX_UINT256) {
                allowed[_sender][msg.sender] -= _amount;
            }
            emit Transfer(msg.sender,_recipient, _amount);
            return true;
        }

        function balanceOf(address _account) public view returns (uint256){
                return balances[_account];
        }

        function allowance(address _owner, address _spender) public view returns (uint256){
                return allowed[_owner][_spender];
        }

        function approve(address _spender, uint256 _amount) public returns (bool){
            allowed[msg.sender][_spender] = _amount;
            emit Approval(msg.sender,_spender, _amount);
            return true;
        }

        function totalSupply() public view returns (uint256){
            return totSupply;
        }
}