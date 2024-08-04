# Function-Frontend
A decentralized application designed to manage an Ethereum-based smart contract. This project includes a Solidity contract for managing account balances and a React-based frontend for interacting with the contract.


# Description
1. Smart Contract (Assessment.sol)

The Solidity smart contract provides functionality for managing account balances:

deposit: Allows the contract owner to deposit Ether into the contract.
withdraw: Enables the contract owner to withdraw Ether from the contract.
getBalance: Returns the current balance stored in the contract.

2. Frontend

The frontend, built with React, allows users to interact with the deployed smart contract:

Connect to MetaMask: Allows users to connect their MetaMask wallets.

View Account Balance: Displays the current balance of the contract.

Deposit: Enables the owner to deposit funds into the contract.

Withdraw: Allows the owner to withdraw funds from the contract.

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
        address payable public owner;
        uint256 public balance;
    
        event Deposit(uint256 amount);
        event Withdraw(uint256 amount);
    
        constructor(uint initBalance) payable {
            owner = payable(msg.sender);
            balance = initBalance;
        }
    
        function getBalance() public view returns(uint256){
            return balance;
        }
    
        function deposit(uint256 _amount) public payable {
            uint _previousBalance = balance;
    
            // Ensure the sender is the owner
            require(msg.sender == owner, "You are not the owner of this account");
    
            // Perform the transaction
            balance += _amount;
    
            // Assert the transaction completed successfully
            assert(balance == _previousBalance + _amount);
    
            // Emit the deposit event
            emit Deposit(_amount);
        }
    
        // Custom error for insufficient balance
        error InsufficientBalance(uint256 balance, uint256 withdrawAmount);
    
        function withdraw(uint256 _withdrawAmount) public {
            require(msg.sender == owner, "You are not the owner of this account");
            uint _previousBalance = balance;
            
            if (balance < _withdrawAmount) {
                revert InsufficientBalance({
                    balance: balance,
                    withdrawAmount: _withdrawAmount
                });
            }
    
            // Withdraw the specified amount
            balance -= _withdrawAmount;
    
            // Assert the balance is correct after withdrawal
            assert(balance == (_previousBalance - _withdrawAmount));
    
            // Emit the withdraw event
            emit Withdraw(_withdrawAmount);
        }
    }

# Interact with the Contract

Once the contract is deployed, you can interact with it via the frontend:

Connect Wallet: Connect your MetaMask wallet to the application.

View Balance: View the current balance of the smart contract.

Deposit: If you are the owner, deposit Ether into the contract.

Withdraw: If you are the owner, withdraw Ether from the contract.


# AUTHOR

Metacrafter Student Ivanne Cres Yabut https://x.com/ivanne_cres

# License

This project is licensed under the author License - see the LICENSE.md file for details.
