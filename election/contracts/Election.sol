// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Election {
    struct Candidate {
        string name;
        uint votes;
        uint id;
    }

    mapping(uint => Candidate) public candidates;
    mapping(address => bool) public voted;
    uint public candidateCount;

    event voteEvent(uint indexed _candidateId);

    constructor() {
        addCandidate("Rama");
        addCandidate("Nick");
    }

    function addCandidate(string memory _name) private {
        Candidate memory candidate = Candidate({
        name : _name,
        votes : 0,
        id : candidateCount
        });
        candidates[candidateCount] = candidate;
        candidateCount++;
    }

    function vote(uint _candidateId) public {
        require(candidateCount > 0);
        require(_candidateId < candidateCount);
        require(voted[msg.sender] == false);
        voted[msg.sender] = true;
        candidates[_candidateId].votes++;
        emit voteEvent(_candidateId);
    }
}
