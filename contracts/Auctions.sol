// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Auctions {
    address public owner;
    uint256 constant DURATION = 2 days;
    uint256 constant FEE = 10;

    struct Auction {
        address payable seller;
        uint256 startPrice;
        uint256 finalPrice;
        uint256 startAt;
        uint256 endAt;
        uint256 discountRate;
        string item;
        bool stopped;
    }

    Auction[] public auctions;

    constructor() {
        owner = msg.sender;
    }

    event AuctionCreated(
        uint256 index,
        string item,
        uint256 startPrice,
        uint256 duration
    );

    event AuctionEnded(uint256 index, uint256 finalPrice, address winner);

    function createAuction(
        uint256 _duration,
        uint256 _startPrice,
        uint256 _discountRate,
        string calldata _item
    ) external {
        uint256 dur = _duration == 0 ? DURATION : _duration;

        require(_startPrice >= _discountRate * dur, "Incorrect price");

        Auction memory newAuction = Auction({
            seller: payable(msg.sender),
            startPrice: _startPrice,
            finalPrice: _startPrice,
            startAt: block.timestamp,
            endAt: block.timestamp + dur,
            discountRate: _discountRate,
            item: _item,
            stopped: false
        });

        auctions.push(newAuction);
        emit AuctionCreated(auctions.length - 1, _item, _startPrice, dur);
    }

    function getPriceFor(uint256 _index) public view returns (uint256) {
        Auction memory auct = auctions[_index];
        require(auct.stopped == false, "stopped!");
        uint256 pastTime = block.timestamp - auct.startAt;
        uint256 discount = auct.discountRate * pastTime;
        return auct.startPrice - discount;
    }

    function buy(uint256 _index) external payable {
        Auction storage currentAuction = auctions[_index];
        require(!currentAuction.stopped, "stopped");
        require(block.timestamp < currentAuction.endAt, "ended");
        uint256 price = getPriceFor(_index);
        require(msg.value >= price, "not enough money");
        currentAuction.stopped = true;
        uint256 refund = msg.value - price;
        if (refund > 0) {
            payable(msg.sender).transfer(refund);
        }
        currentAuction.seller.transfer(price - ((price * FEE) / 100));
        emit AuctionEnded(_index, price, msg.sender);
    }
}
