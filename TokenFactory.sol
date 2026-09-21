// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./LaunchedToken.sol";

contract TokenFactory {
    address public owner;
    uint256 public launchFee = 0.001 ether;
    address[] public allTokens;

    event TokenLaunched(
        address indexed token,
        address indexed creator,
        string name,
        string symbol,
        uint256 supply
    );

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function createToken(
        string memory name,
        string memory symbol,
        uint256 supply
    ) external payable returns (address) {
        require(msg.value >= launchFee, "fee too low");
        require(supply > 0, "supply must be > 0");

        LaunchedToken token = new LaunchedToken(name, symbol, supply, msg.sender);
        allTokens.push(address(token));

        emit TokenLaunched(address(token), msg.sender, name, symbol, supply);
        return address(token);
    }

    function tokenCount() external view returns (uint256) {
        return allTokens.length;
    }

    function setFee(uint256 newFee) external onlyOwner {
        launchFee = newFee;
    }

    function withdraw() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
}
