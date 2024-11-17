# Challenge Reward System

## Overview
The `ChallengeRewardSystem` is a smart contract built on the Ethereum blockchain that allows users to register, complete, and track challenges to earn reward points. These points can be redeemed once a threshold is met. The contract is managed by an owner with administrative privileges for certain functions.

## Features
- **Challenge Registration**: Users can register new challenges with a title.
- **Challenge Completion**: Users can mark a challenge as completed if done within 12 hours of creation, earning points.
- **Reward Points System**: Users receive 5 points for each completed challenge.
- **Point Redemption**: Users can redeem their points when they have enough accumulated.
- **Administrative Controls**: The contract owner can reset user points.

## Smart Contract Details
- **Contract Name**: `ChallengeRewardSystem`
- **License**: MIT
- **Solidity Version**: `^0.8.26`

## Constants
- `REWARD_POINTS`: Points awarded per completed challenge (5 points).
- `REDEEM_THRESHOLD`: Minimum points required for redemption (20 points).
- `COMPLETION_WINDOW`: The time limit for completing a challenge (12 hours).

## State Variables
- `owner`: The address of the contract owner.
- `userChallenges`: A mapping that stores challenges for each user.
- `userPoints`: A mapping that tracks the points balance for each user.

## Functions

### Public/External Functions
- **`registerChallenge(string memory _title)`**: Registers a new challenge with a specified title for the caller.
  - *Requirements*: The title must not be empty.

- **`completeChallenge(uint _challengeIndex)`**: Marks a specified challenge as completed if done within the allowed time window (12 hours) and awards points.
  - *Requirements*: The challenge must not be completed already, and the index must be valid.

- **`redeemPoints(uint _points)`**: Allows the caller to redeem points if they have enough in their balance.
  - *Requirements*: The caller must have sufficient points for redemption.

- **`getPointsBalance()`**: Returns the points balance of the caller.
  - *Returns*: The total points balance.

- **`getChallenges()`**: Returns a list of challenges registered by the caller.
  - *Returns*: An array of `Challenge` structs.

### Owner-Only Function
- **`resetUserPoints(address _user)`**: Resets the points of a specified user to zero.
  - *Requirements*: Only callable by the contract owner.

## Usage Instructions
1. **Deploy the Contract**: Deploy the `ChallengeRewardSystem` contract on the desired Ethereum network.
2. **Register Challenges**: Users can call `registerChallenge()` with a non-empty title to add a new challenge.
3. **Complete Challenges**: Use `completeChallenge()` with the index of the challenge within 12 hours to earn points.
4. **Check Balance**: Call `getPointsBalance()` to view the current points.
5. **Redeem Points**: Redeem accumulated points using `redeemPoints()` when the required points are met.
6. **View Challenges**: Use `getChallenges()` to see all challenges registered by the caller.
7. **Admin Control**: The contract owner can reset user points using `resetUserPoints()`.

## Security Considerations
- Ensure only the owner address can call `resetUserPoints()`.
- `onlyOwner` modifier is used to restrict administrative functions.
- Points deduction logic is verified using the `assert()` statement for integrity.

