// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Test} from "forge-std/Test.sol";
import {MerkleAirdrop} from "../src/MerkleAirdrop.sol";
import {CoffeeToken} from "../src/CoffeeToken.sol";
import {ZkSyncChainChecker} from "foundry-devops/src/ZkSyncChainChecker.sol";
import {DeployMerkleAirdrop} from "../script/DeployMerkleAirdrop.s.sol";

contract MerkleAirdropTest is ZkSyncChainChecker, Test {

    MerkleAirdrop private merkleAirdrop;
    CoffeeToken private coffeeToken;
    address private gasPayer;
    address private user;
    uint256 private userKey;

    uint256 public constant AMOUNT = 10 ether;
    bytes32 public constant MERKLE_ROOT = 0xccb309293eed85a238c26406b58308e2846931836195702f5feb87a0000c0419;
    bytes32 proofOne = 0x50307774e64ddd9e65a8ffe90976869c1f52c4a27bad56f4e383c530d6b75217;
    bytes32 proofTwo = 0x8aceb2bc486afcff8c556bdc8e44f21f32686822d57f25a4b33ca358a4a5dc45;
    bytes32[] public MERKLE_PROOF = [proofOne, proofTwo];

    function setUp() public {
        if (!isZkSyncChain()) {
            // deploy with the script
            DeployMerkleAirdrop deployer = new DeployMerkleAirdrop();
            (merkleAirdrop, coffeeToken) = deployer.deployMerkleAirdropAndCoffeeToken();
        } else {
            // deploy with the contract
            coffeeToken = new CoffeeToken();
            merkleAirdrop = new MerkleAirdrop(MERKLE_ROOT, coffeeToken);
            coffeeToken.mint(address(merkleAirdrop), AMOUNT);
        }
        (user, userKey) = makeAddrAndKey("user");
    }


    function testUsersCanClaim() public {
        uint256 startingBalance = coffeeToken.balanceOf(user);
        bytes32 digest = merkleAirdrop.getMessageHash(user, AMOUNT);

        // sign the message
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(userKey, digest);

        // gasPayer calls calim using the signed message
        vm.prank(gasPayer);
        merkleAirdrop.claim(user, AMOUNT, MERKLE_PROOF, v, r, s);

        // check the user's balance
        uint256 endingBalance = coffeeToken.balanceOf(user);
        assertEq(endingBalance, startingBalance + AMOUNT);
    }

}