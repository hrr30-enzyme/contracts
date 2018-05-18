pragma solidity ^0.4.23;

import "./Ownable.sol";

contract Question {

    uint minBounty = .003 ether;
    uint duration = 1 days;
    uint bounty;
    address owner;

    constructor() public {
        require(msg.value >= minBounty);
        bounty = msg.value;
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}