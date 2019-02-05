pragma solidity 0.4.24;

contract Election {
    
    struct Candidate {
        string name;
        uint voteCount;
    }

    struct Voter {
        address voterID;
        bool isValidated;
        bool hasVoted;
        uint vote;
        uint weight;
    }

    address public owner;
    string public name;
    mapping(address => Voter) public voters;
    Candidate[] public candidates;
    uint public candidateCount;

    event ElectionResult(string candidateName, uint voteCount);

    constructor(string _name) public {
        owner = msg.sender;
        name = _name;
        candidateCount = 0;
    }

    function addCandidate(string _name) public {
        candidates.push(Candidate(_name, 0));
        candidateCount += 1; 
    }

    function registerVoter() public {
        require(voters[msg.sender].voterID != msg.sender, "voter has already been registered");

        // This will automaticaly instanciate the new instance of the array
        // calling the voters variable calls the constructor for the array
        voters[msg.sender].voterID = msg.sender;
        voters[msg.sender].isValidated = false;
        voters[msg.sender].hasVoted = false;
        voters[msg.sender].vote = 0;
        voters[msg.sender].weight = 1;
    }

    function validateVoter(address voter) public {
        require(msg.sender == owner, "Only owner of election can authorize a voter");
        require(!voters[voter].isValidated, "The voter has already been authorized to vote");
        
        voters[voter].isValidated = true;
    }        

    function vote(uint voteIndex) public {
        require(voters[msg.sender].voterID == msg.sender, "voter has not registered");
        require(!voters[msg.sender].hasVoted, "voter has already voted");
        require(voters[msg.sender].isValidated, "voter has not been authorized to vote");
        require(voteIndex >= 1 && voteIndex <= candidateCount, "invalid candidate selected");

        voters[msg.sender].vote = (voteIndex-1);
        voters[msg.sender].hasVoted = true;

        candidates[voteIndex-1].voteCount += voters[msg.sender].weight;
    }


    function end() public {
        //make sure only owner can end voting
        require(msg.sender == owner);
        
        //announce each candidates results
        for (uint i=0; i < candidates.length; i++) {
            emit ElectionResult(candidates[i].name, candidates[i].voteCount);
        }
        
        //destroy the contract
        selfdestruct(owner);
    }


}