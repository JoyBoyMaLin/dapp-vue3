// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

contract CoinToss is VRFConsumerBaseV2 {
    VRFCoordinatorV2Interface COORDINATOR;
    LinkTokenInterface LINKTOKEN;
    // Your subscription ID.
    uint64 s_subscriptionId;

    // Rinkeby coordinator. For other networks,
    // see https://docs.chain.link/docs/vrf-contracts/#configurations
    address vrfCoordinator = 0x6168499c0cFfCaCD319c818142124B7A15E857ab;

    // Rinkeby LINK token contract. For other networks,
    // see https://docs.chain.link/docs/vrf-contracts/#configurations
    address link = 0x01BE23585060835E02B77ef475b0Cc51aA1e0709;

    // The gas lane to use, which specifies the maximum gas price to bump to.
    // For a list of available gas lanes on each network,
    // see https://docs.chain.link/docs/vrf-contracts/#configurations
    bytes32 keyHash = 0xd89b2bf150e3b9e13446986e571fb9cab24b13cea0a43ea20a6049a85cc807cc;

    // Depends on the number of requested values that you want sent to the
    // fulfillRandomWords() function. Storing each word costs about 20,000 gas,
    // so 100,000 is a safe default for this example contract. Test and adjust
    // this limit based on the network that you select, the size of the request,
    // and the processing of the callback request in the fulfillRandomWords()
    // function.
    uint32 callbackGasLimit = 100000;

    // The default is 3, but you can set this higher.
    uint16 requestConfirmations = 3;

    // For this example, retrieve 2 random values in one request.
    // Cannot exceed VRFCoordinatorV2.MAX_NUM_WORDS.
    uint32 numWords = 1;

    address s_owner;

    uint256 private constant ROLL_IN_PROGRESS = 42;

    mapping(uint256 => address) private s_rollers;
    mapping(uint256 => uint256) private s_results;
    mapping(uint256 => uint256) private s_bet_amounts;
    mapping(uint256 => uint256) private s_guess;
    mapping(uint256 => bool) private s_payout;
    mapping(address => uint256) private joined;

    uint public max_price;
    uint public min_price;
    uint256 public s_odds = 198;

    event DiceRolled(uint256 requestId, address roller);
    event DiceLanded(uint256 requestId, address roller, uint256 guess, uint256 rollValue);

    constructor(uint64 subscriptionId) VRFConsumerBaseV2(vrfCoordinator){
        COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
        LINKTOKEN = LinkTokenInterface(link);
        s_owner = msg.sender;
        s_subscriptionId = subscriptionId;
        min_price = 0.01 ether;
        max_price = 1 ether;
    }

    function rollDice(bool guess) public payable returns (uint256 requestId) {
        require(msg.value >= min_price, "Minimum bet is 0.01 ether");
        require(msg.value <= max_price, "Maximum bet is 1 ether");
        address roller = msg.sender;
        requestId = COORDINATOR.requestRandomWords(
            keyHash,
            s_subscriptionId,
            requestConfirmations,
            callbackGasLimit,
            numWords
        );
        s_rollers[requestId] = roller;
        s_results[requestId] = ROLL_IN_PROGRESS;
        s_bet_amounts[requestId] = msg.value;
        if (guess) {
            s_guess[requestId] = 2;
        } else {
            s_guess[requestId] = 1;
        }
        emit DiceRolled(requestId, roller);
        return requestId;
    }


    function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) internal override {
        uint256 rollValue = randomWords[0] % 2 + 1;
        s_results[requestId] = rollValue;
        uint256 guess = s_guess[requestId];
        address roller = s_rollers[requestId];
        emit DiceLanded(requestId, roller, guess, rollValue);
        if (guess == rollValue && s_payout[requestId] == false) {
            s_payout[requestId] = true;
            payable(roller).transfer(s_bet_amounts[requestId] * s_odds / 100);
        }
    }

    function setOdds(uint256 odds) external {
        require(odds > 0, "Odds must be greater than 0");
        require(odds < 2, "Odds must be less than 2");
        require(msg.sender == s_owner, "Only the owner can set the odds");
        s_odds = odds;
    }

    function getResult(uint256 requestId) public view onlyOwner returns (string memory) {
        require(s_results[requestId] != 0, "Dice not rolled");
        require(s_results[requestId] != ROLL_IN_PROGRESS, "Roll in progress");
        return s_results[requestId] == s_guess[requestId] ? "WIN" : "LOSE";
    }


    function withdrawFund() external {
        require(msg.sender == s_owner);
        payable(msg.sender).transfer(address(this).balance);
    }

    modifier onlyOwner() {
        require(msg.sender == s_owner);
        _;
    }

    function join() external payable {
        require(msg.sender != address(this));
        joined[msg.sender] = joined[msg.sender] + msg.value;
    }
}
