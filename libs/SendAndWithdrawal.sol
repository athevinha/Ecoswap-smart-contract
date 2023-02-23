// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Owner {
    // variable
    mapping(address => uint ) public addressBalanceMapping;
    struct userWalletStruct{
        address _address;
        uint _amount;
    }
    userWalletStruct public user;
    // Function contract
    function updateUserWallet(address _address) private{
        user._address = _address;
        user._amount = address(_address).balance;
    }

    function deposit() public payable{
        addressBalanceMapping[address(this)] += msg.value;
        updateUserWallet(msg.sender);
    }

    function getContractBalance() public view returns(uint){
        return address(this).balance;
    }
    function withdrawAll() public{
        address payable acc = payable(msg.sender);
        acc.transfer(getContractBalance());
        addressBalanceMapping[address(this)] = 0;
    }
    function withdrawToAddress(address payable acc) public{
        acc.transfer(getContractBalance());
        addressBalanceMapping[address(this)] = 0;
        updateUserWallet(msg.sender);
    }
}