// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract ChallengeRewardSystem {
    address public owner;
    uint public constant REWARD_POINTS = 5; // Points awarded per completed challenge
    uint public constant REDEEM_THRESHOLD = 20; // Points required for redemption
    uint public constant COMPLETION_WINDOW = 12 hours; // Time limit for completing a challenge

    struct Challenge {
        string title;
        uint createdAt;
        bool isCompleted;
    }

    mapping(address => Challenge[]) private userChallenges;
    mapping(address => uint) private userPoints;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Registers a new challenge for the caller
    /// @param _title Title of the challenge
    function registerChallenge(string memory _title) public {
        require(bytes(_title).length > 0, "Challenge title cannot be empty");

        userChallenges[msg.sender].push(Challenge({
            title: _title,
            createdAt: block.timestamp,
            isCompleted: false
        }));
    }

    /// @notice Marks a challenge as completed if done within 24 hours of creation and awards points
    /// @param _challengeIndex Index of the challenge to be marked as complete
    function completeChallenge(uint _challengeIndex) public {
        require(_challengeIndex < userChallenges[msg.sender].length, "Challenge index out of range");

        Challenge storage challenge = userChallenges[msg.sender][_challengeIndex];
        require(!challenge.isCompleted, "Challenge has already been completed");

        // Ensure the challenge is completed within the allowed time window
        if (block.timestamp <= challenge.createdAt + COMPLETION_WINDOW) {
            challenge.isCompleted = true;
            userPoints[msg.sender] += REWARD_POINTS;
        } else {
            revert("Challenge completion window has expired");
        }
    }

    /// @notice Redeems a specified amount of points for the caller
    /// @param _points Amount of points to redeem
    function redeemPoints(uint _points) public {
        require(userPoints[msg.sender] >= _points, "Insufficient points for redemption");

        uint previousPoints = userPoints[msg.sender];
        userPoints[msg.sender] -= _points;

        // Ensure points deduction is correct
        assert(userPoints[msg.sender] == previousPoints - _points);
    }

    /// @notice Returns the total points balance of the caller
    /// @return The caller's points balance
    function getPointsBalance() public view returns (uint) {
        return userPoints[msg.sender];
    }

    // Function for admin to reset user points
    function resetUserPoints(address _user) external onlyOwner {
        require(_user != address(0), "Invalid user address");
        userPoints[_user] = 0;
    }

    /// @notice Returns the list of challenges for the caller
    /// @return An array of Challenge structs
    function getChallenges() public view returns (Challenge[] memory) {
        return userChallenges[msg.sender];
    }

}
