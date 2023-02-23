// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract HistoryTransact {
    address public ownerAddress;
    constructor() {
        ownerAddress = msg.sender;
    }
    struct Transaction{
        uint _amount;
        uint _time;
    }
    struct Balance {
        uint totalBalance;
        uint totalDeposits;
        uint totalWithdrawals;

        mapping(uint => Transaction) deposits;
        mapping(uint => Transaction) withdrawals;
    }
    mapping(address => Balance) public balances;

    bytes32 public privateKeyHashValue;
    string private privateKey;
    event ErrorLogging(string ErrorLog);

    modifier onlyOwner(){
        require(msg.sender == ownerAddress, "Your are not Owners");
        _;
    } 

    function getBalance(address _from, uint _count) public view returns(Transaction memory){
        return balances[_from].deposits[_count];
    }
    function setPrivateKeyHash(string memory _privateKey) public onlyOwner{
        privateKeyHashValue = keccak256(abi.encodePacked(_privateKey));
        privateKey = _privateKey;
    }
    function checkPrivateKeyHash(string memory _privateKey) public view returns(bool){
        bytes32 _hashValue = keccak256(abi.encodePacked(_privateKey));
        return privateKeyHashValue == _hashValue;
    }

    function depositETH() public payable {
        balances[msg.sender].totalBalance += msg.value;
        Transaction memory _transaction = Transaction(msg.value, block.timestamp);
        balances[msg.sender].deposits[balances[msg.sender].totalDeposits] = _transaction;
        balances[msg.sender].totalDeposits++;
    }

    function withdrawETH(address _to, uint _amount, string memory _privateKey) public payable{
        require(privateKeyHashValue == keccak256(abi.encodePacked(_privateKey)), "Your are not Owners");
        require(_amount <= address(this).balance,"Don't have enough fund");

        balances[_to].totalBalance -= msg.value;
        Transaction memory _transaction = Transaction(_amount, block.timestamp);
        balances[_to].withdrawals[balances[_to].totalWithdrawals] = _transaction;
        balances[_to].totalWithdrawals++;
        address payable to = payable(_to);
        to.transfer(_transaction._amount);
    }

    // function tryCatchLog() public {
    //     try  { // only call with another contract
    //     }
    //     catch Error(string memory ErrorLog) {
    //         emit ErrorLogging(ErrorLog);
    //     }
    // }
}