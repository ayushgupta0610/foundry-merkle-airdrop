// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Script} from "forge-std/Script.sol";
import {MerkleAirdrop} from "../src/MerkleAirdrop.sol";
import {CoffeeToken} from "../src/CoffeeToken.sol";
import {IERC20, SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract DeployMerkleAirdrop is Script {

    bytes32 public constant MERKLE_ROOT = 0xccb309293eed85a238c26406b58308e2846931836195702f5feb87a0000c0419;
    uint256 public constant AIRDROP_AMOUNT = 90 * 1e18;

    function run() public returns (MerkleAirdrop, CoffeeToken) {
        return deployMerkleAirdropAndCoffeeToken();
    }

    function deployMerkleAirdropAndCoffeeToken() public returns (MerkleAirdrop, CoffeeToken) {
        vm.startBroadcast();
        CoffeeToken coffeeToken = new CoffeeToken();
        MerkleAirdrop merkleAirdrop = new MerkleAirdrop(MERKLE_ROOT, coffeeToken);
        coffeeToken.mint(coffeeToken.owner(), AIRDROP_AMOUNT);
        coffeeToken.transfer(address(merkleAirdrop), AIRDROP_AMOUNT);
        vm.stopBroadcast();
        return (merkleAirdrop, coffeeToken);
    }

}