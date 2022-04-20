// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC1155/presets/ERC1155PresetMinterPauser.sol";

import "../interfaces/IDoll.sol";

contract BlindBox is ERC1155PresetMinterPauser, Ownable {
    using Strings for uint256;
    IDoll immutable doll;
    uint256 public mintPrice = 0.01 ether;
    uint256 private _totalSupply;
    constructor(IDoll _doll) ERC1155("https://blindbox.hundunlin.com/api/item/{id}.json") {
        doll = IDoll(_doll);
    }

    function mintBoxNftMeta() public payable {
        require(msg.value >= mintPrice);
        _mint(msg.sender, _totalSupply, 1, "");
        _totalSupply += 1;
    }

    function openBox(uint256 _id) public payable {
        _burn(msg.sender, _id, 1);
        doll.awardItem(msg.sender, Strings.toString(_id));
    }

}