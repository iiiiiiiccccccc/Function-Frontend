// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment the line below if you want to use console.log for debugging in Hardhat
// import "hardhat/console.sol";

contract Assessment {
    // State variables
    address payable public owner; // Address of the contract owner, set as payable to allow sending Ether
    uint256 public balance;       // Stores the balance of the contract

    // Events that are emitted on specific actions
    event Deposit(uint256 amount); // Event triggered when a deposit is made
    event Withdraw(uint256 amount); // Event triggered when a withdrawal is made

    // Constructor to initialize the contract with an initial balance
    constructor(uint initBalance) payable {
        owner = payable(msg.sender); // Set the contract deployer as the owner
        balance = initBalance;       // Initialize the contract balance with the provided value
    }

    // Function to retrieve the current balance of the contract
    function getBalance() public view returns(uint256) {
        return balance; // Return the contract's balance
    }

    // Function to deposit a specific amount into the contract
    function deposit(uint256 _amount) public payable {
        uint _previousBalance = balance; // Store the current balance for later assertion

        // Ensure the function caller is the contract owner
        require(msg.sender == owner, "You are not the owner of this account");

        // Perform the deposit by adding the specified amount to the balance
        balance += _amount;

        // Assert that the balance has been correctly updated
        assert(balance == _previousBalance + _amount);

        // Emit the Deposit event to log the deposit action
        emit Deposit(_amount);
    }

    // Custom error to handle insufficient balance during withdrawals
    error InsufficientBalance(uint256 balance, uint256 withdrawAmount);

    // Function to withdraw a specific amount from the contract
    function withdraw(uint256 _withdrawAmount) public {
        // Ensure the function caller is the contract owner
        require(msg.sender == owner, "You are not the owner of this account");
        
        uint _previousBalance = balance; // Store the current balance for later assertion

        // Check if the balance is sufficient for the withdrawal, revert with custom error if not
        if (balance < _withdrawAmount) {
            revert InsufficientBalance({
                balance: balance,
                withdrawAmount: _withdrawAmount
            });
        }

        // Perform the withdrawal by subtracting the specified amount from the balance
        balance -= _withdrawAmount;

        // Assert that the balance has been correctly updated
        assert(balance == (_previousBalance - _withdrawAmount));

        // Emit the Withdraw event to log the withdrawal action
        emit Withdraw(_withdrawAmount);
    }
}

