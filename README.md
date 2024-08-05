# Function-Frontend
A decentralized application designed to manage an Ethereum-based smart contract. This project includes a Solidity contract for a betting system and a React-based frontend for interacting with the contract.


# Steps to Run the Project Locally

To get the project up and running on your computer, follow these steps after cloning the GitHub repository:

Open a terminal in the project directory and install the necessary packages by running:

npm i

Open two additional terminals in VS Code to manage different processes.
In the second terminal, start a local blockchain by running:

npx hardhat node

In the third terminal, deploy the smart contract to the local blockchain:

npx hardhat run --network localhost scripts/deploy.js

Return to the first terminal and launch the frontend by running:

npm run dev

Your project should now be running on your localhost, typically accessible at http://localhost:3000/.

# Solidity Smart Contract Code

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

# State Variables:

owner: Stores the address of the contract's owner.

contractBalance: Tracks the balance of the contract, used to manage payouts.

Events:
Deposit: Emitted when a deposit is made (though not used explicitly in this code).

BetPlaced: Emitted when a bet is placed, includes details like the bet amount, random number, and whether it was a win.

Win: Emitted when a user wins a bet.

Lose: Emitted when a user loses a bet.

# Functions:

getBalance(): Returns the contract's current Ether balance.

determineWin(uint256 randomNumber): Internal function that checks if the bet is a win based on a random number.

placeBet(): Allows users to place a bet of exactly 1 ETH. It generates a random number, determines if the bet is a win, and processes the bet accordingly. If the user wins, they receive 2 ETH.

This contract is now a simple betting system where users can bet 1 ETH for a chance to win 2 ETH.



# Interacting with the Betting Contract 

This guide will walk you through interacting with the Assessment betting smart contract, including connecting your wallet, placing a bet, and checking the contract balance.

1. Connecting to the Contract

Step 1: Ensure you have a web3-enabled wallet like MetaMask installed and connected to the appropriate Ethereum network (e.g., a testnet or mainnet depending on deployment).

Step 2: Open your DApp or frontend interface where the contract is deployed.

Step 3: Use the "Connect Wallet" button to link your MetaMask wallet to the DApp. This will allow you to interact with the contract.

2. Checking the Contract Balance

Step 1: After connecting your wallet, you can check the balance of the contract to see how much Ether is available.

Step 2: Click on the "Check Contract Balance" button. The balance will be retrieved using the getBalance() function and displayed in the DApp interface.

3. Placing a Bet

Step 1: Ensure you have exactly 1 ETH available in your wallet, as this contract requires a fixed bet amount.

Step 2: In the DApp, navigate to the betting section and click the "Place Bet" button.

Step 3: Confirm the transaction in MetaMask, which sends 1 ETH to the contract as your bet.

Step 4: The contract will generate a random number and determine if you've won based on predefined rules (winning numbers are 1, 3, and 5).

If you win, you will automatically receive 2 ETH back to your wallet.

If you lose, the contract keeps the 1 ETH, and you’ll be notified of the result.

4. Understanding Bet Outcomes

Win: If the random number generated is 1, 3, or 5, the bet is considered a win. You will receive 2 ETH, and a Win event will be emitted.

Lose: If the random number is any other number, the bet is a loss, and a Lose event is emitted. The contract retains your 1 ETH bet.

5. Viewing Bet History (Optional)

The contract emits events for each bet placed (BetPlaced), including whether the bet was won or lost. Depending on the frontend implementation, you may be able to see your betting history directly in the DApp interface.

6. Owner Actions (For Contract Owner Only)

Withdrawing Funds: The contract owner can withdraw Ether from the contract using an administrative interface. This is typically done to manage the contract's funds or for payouts.

Important Considerations
Ensure you are aware of gas fees associated with each transaction on the Ethereum network.

This contract uses randomness to determine outcomes, so each bet has a chance to win or lose.

The contract must have sufficient balance to pay out winners, so it's important to check the balance before placing a bet.


# AUTHOR

Metacrafter Student Ivanne Cres Yabut https://x.com/ivanne_cres

# License

This project is licensed under the author License - see the LICENSE.md file for details.
