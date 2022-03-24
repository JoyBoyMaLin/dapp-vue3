// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Coin {
    address public owner;
    mapping(address => uint) public joined;
    uint public max_price;
    uint public min_price;

    event result(bool correct, bool guess);
    constructor() {
        owner = msg.sender;
        min_price = 0.01 ether;
        max_price = 1 ether;
    }

    function random() public view returns (bool) {
        return (uint(keccak256(abi.encodePacked(block.timestamp))) % 2) == 0;
    }

    function withdrawFund() external {
        require(msg.sender == owner);
        payable(msg.sender).transfer(address(this).balance);
    }

    function join() external payable {
        require(msg.sender != address(this));
        require(joined[msg.sender] == 0);
        joined[msg.sender] = msg.value;
    }

    function toss(bool guess) external payable {
        uint value = msg.value;
        require(value >= min_price);
        require(value <= max_price);
        bool correct = random();
        emit result(correct, guess);
        if (correct == guess) {
            payable(msg.sender).transfer(value * 2);
        }
    }
}
