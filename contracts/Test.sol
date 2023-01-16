// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Test {
    struct Payment {
        address from;
        uint256 date;
        uint256 value;
        string message;
    }

    struct Balance {
        uint256 timesPayed;
        mapping(uint256 => Payment) payments;
    }

    mapping(address => Balance) public balances;

    event Paid(address indexed _from, uint amount );

    receive() external payable {
      emitPay();
    }

    function emitPay() public payable {
      emit Paid(msg.sender, msg.value);
    }

    function pay(string memory message) public payable {
        uint256 _nextIndex = balances[msg.sender].timesPayed;
        balances[msg.sender].timesPayed++;
        
        Payment memory newPayment = Payment(
            msg.sender,
            block.timestamp,
            msg.value,
            message
        );

        balances[msg.sender].payments[_nextIndex] = newPayment;
    }

    function getPayment(address owner, uint _i) public view returns(Payment memory) {
        return balances[owner].payments[_i];
    }

    function contractBalance() public view  returns(uint){
        return address(this).balance;
    }
}
