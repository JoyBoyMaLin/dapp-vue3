// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IDoll {
    function awardItem(address player, string memory tokenURI) external returns (uint256);
}
