pragma solidity 0.4.24;

contract SimpleCounter {
    int counter; // state variable
    address owner;
    uint public lockedUntilTime;
    uint public lockDurationMinutes;


    event counterUpdated(int newCounterValue);

    modifier ownerOnly() {
        require(msg.sender == owner, "only the contract owner may perform this task");
        _;
    }     

    modifier lockTimeoutHasExpired() {
        require(now >= lockedUntilTime, "Lock timer is still active");
        _;
    }

    constructor(uint _lockDurationMinutes) public {
        counter = 0;
        owner = msg.sender;
        lockDurationMinutes = _lockDurationMinutes;
        lockedUntilTime = now + (lockDurationMinutes * 1 minutes);
    }

    function getTimeNow() public view returns(uint) {
        return now;
    }

    function getCounter() public view returns(int) {
        return counter;
    }

    function increment() public {
        counter += 1;
        emit counterUpdated(counter);
    }

    function decrement() public {
        counter -= 1;
        emit counterUpdated(counter);
    }

    function reset() public ownerOnly lockTimeoutHasExpired {
        counter = 0;
        lockedUntilTime = now + (lockDurationMinutes * 1 minutes);
        emit counterUpdated(counter);
    }
}
