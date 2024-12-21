// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LearnToEarn {
    address public owner;
    uint256 public mentoringTokenPrice = 1 ether; // Price per token in wei
    uint256 public totalTokens;

    struct Learner {
        uint256 tokensEarned;
        uint256 tokensRedeemed;
    }

    mapping(address => Learner) public learners;

    event TokensEarned(address indexed learner, uint256 amount);
    event TokensRedeemed(address indexed learner, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function earnTokens(address learner, uint256 amount) external onlyOwner {
        learners[learner].tokensEarned += amount;
        totalTokens += amount;
        emit TokensEarned(learner, amount);
    }

    function redeemTokens(uint256 amount) external {
        require(learners[msg.sender].tokensEarned >= amount, "Insufficient tokens");
        learners[msg.sender].tokensEarned -= amount;
        learners[msg.sender].tokensRedeemed += amount;
        emit TokensRedeemed(msg.sender, amount);
    }

    function getLearnerDetails(address learner) external view returns (uint256 earned, uint256 redeemed) {
        earned = learners[learner].tokensEarned;
        redeemed = learners[learner].tokensRedeemed;
    }

    function setMentoringTokenPrice(uint256 newPrice) external onlyOwner {
        mentoringTokenPrice = newPrice;
    }
}
