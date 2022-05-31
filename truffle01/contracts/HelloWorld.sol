// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract HelloWorld
{
    string private helloWorldmsg="Hello World from Ethereum Solidity!!!";
    
    function  getMessage() public view returns(string memory)
    {
        return helloWorldmsg;
    }
}