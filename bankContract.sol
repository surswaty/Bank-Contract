pragma solidity ^0.5.0;

interface IBank{
    function deposit() external payable returns(bool);
    function withdraw(uint _amount) external returns(bool);
    function checkBalance() external view returns(uint);
}

contract Bank is IBank{
    
    mapping (address => uint)balances;
    address[] addresses;
    address payable owner;
    constructor() payable public{
        owner = msg.sender;
        require(msg.value >= 50 ether);
    }
    
    function deposit() external payable returns(bool){
        require(msg.value > 0);
        balances [msg.sender]+= msg.value;
        addresses.push(msg.sender);
        return true;
    }
    
    function withdraw(uint _amount) external returns(bool){
        uint amount = _amount * 1000000000000000000;
        require(balances[msg.sender] >= amount);
        balances[msg.sender] -= amount;
        address(msg.sender).transfer(amount);
    }
    function checkBalance()external view returns(uint){
       return balances[msg.sender];
    }
    
    //Only the owner can invoke this function
    function showTotalBankfund()public view returns(uint){
        require(msg.sender == owner);
            return address(this).balance;
    }
    //Only owner can invoke this function
    function totalActiveAccounts()public view returns(uint){
        require(msg.sender == owner);
        return addresses.length;
    }
    
    //Distructor to remove contract from the network;
    function removeContract()public payable{
        selfdestruct(owner);
    }
    
}
