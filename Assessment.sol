// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Assessment {
    // State variables
    address payable public owner;        // Address of the contract owner
    uint256 public contractBalance;      // Tracks the balance of the contract

    // Events that are emitted on specific actions
    event Deposit(address indexed user, uint256 amount);         // Event triggered when a deposit is made
    event BetPlaced(address indexed user, uint256 amount, uint256 randomNumber, bool isWin); // Event triggered when a bet is placed
    event Win(address indexed user, uint256 amount);             // Event triggered when a user wins a bet
    event Lose(address indexed user, uint256 amount);            // Event triggered when a user loses a bet

    // Constructor to initialize the contract, setting the deployer as the owner
    constructor() payable {
        owner = payable(msg.sender);      // Set the contract deployer as the owner
        contractBalance = 0;              // Initialize the contract balance to zero
    }

    // Function to get the current balance of the contract (in Ether)
    function getBalance() public view returns (uint256) {
        return address(this).balance;     // Return the contract's Ether balance
    }

    // Internal function to determine if a bet is a win based on a random number
    function determineWin(uint256 randomNumber) internal pure returns (bool) {
        return (randomNumber == 1 || randomNumber == 3 || randomNumber == 5); // Win if the number is 1, 3, or 5
    }

    // Function to place a bet (1 ETH) and potentially win 2 ETH
    function placeBet() public payable {
        require(msg.value == 1 ether, "Bet amount must be exactly 1 ETH"); // Ensure the bet amount is exactly 1 ETH

        // Generate a random number between 1 and 6
        uint256 randomNumber = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender))) % 6 + 1;
        
        // Determine if the bet is a win
        bool isWin = determineWin(randomNumber);

        // If the user wins the bet
        if (isWin) {
            uint256 winAmount = 2 ether; // The winning amount is 2 ETH
            require(contractBalance >= winAmount, "Contract balance is insufficient to pay out winnings"); // Ensure the contract has enough balance
            payable(msg.sender).transfer(winAmount); // Transfer the winnings to the user
            contractBalance -= winAmount; // Update the contract's balance
            emit Win(msg.sender, winAmount); // Emit the Win event
        } else {
            emit Lose(msg.sender, msg.value); // Emit the Lose event if the user loses
        }

        contractBalance += msg.value; // Update the contract balance with the bet amount
        emit BetPlaced(msg.sender, msg.value, randomNumber, isWin); // Emit the BetPlaced event with the details
    }
}
