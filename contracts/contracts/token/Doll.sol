// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/presets/ERC721PresetMinterPauserAutoId.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "../interfaces/IDoll.sol";

contract Doll is ERC721PresetMinterPauserAutoId, IDoll {
    using Counters for Counters.Counter;
    Counters.Counter public _tokenIds;

    constructor() ERC721PresetMinterPauserAutoId("Doll", "Doll", "https://doll.hundunlin.com/token/") {}

    function awardItem(address player, string memory tokenURI)
    public override
    returns (uint256)
    {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(player, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }

}
