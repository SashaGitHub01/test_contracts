// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Test {
    address creator;

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

    event Paid(address indexed _from, uint256 amount, uint256 date);

    constructor() {
        creator = msg.sender;
    }

    receive() external payable {
        emitPay();
    }

    function emitPay() public payable {
        emit Paid(msg.sender, msg.value, block.timestamp);
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

    function getPayment(address owner, uint256 _i)
        public
        view
        returns (Payment memory)
    {
        return balances[owner].payments[_i];
    }

    function contractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    modifier onlyOwner() {
        require(msg.sender == creator, "You are not a creator");
        _;
    }

    function withdraw(address payable _to) external onlyOwner() {
        _to.transfer(address(this).balance);
    }
}
