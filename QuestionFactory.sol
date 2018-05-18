pragma solidity ^0.4.23;

import "./Ownable.sol";

contract Question is Ownable {

    uint duration = 1 days;
    uint bounty;
    uint minBounty = .003 ether;

    constructor() {
        require(msg.value >= minBounty);
        bounty = msg.value;
    }
}