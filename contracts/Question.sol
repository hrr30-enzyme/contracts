pragma solidity ^0.4.23;

contract Question {

    uint minBounty;
    uint duration;
    uint endTime;
    uint bounty;
    address asker;
    address owner;

    event TimeExtended(uint endTime, uint bounty);

    function extendTime() public payable questionOpen {
        require(duration < 30 days && msg.value > minBounty);
        bounty += minBounty;
        endTime += duration;
        emit TimeExtended(endTime, bounty);
    }


    modifier questionOpen() {
        require(now <= endTime);
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}

