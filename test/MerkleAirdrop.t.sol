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

    uint256 public constant AMOUNT = 25 ether;
    bytes32 public constant MERKLE_ROOT = 0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4;
    bytes32 proofOne = 0x0fd7c981d39bece61f7499702bf59b3114a90e66b51ba2c53abdf7b62986c00a;
    bytes32 proofTwo = 0xe5ebd1e1b5a5478a944ecab36a9a954ac3b6b8216875f6524caa7a1d87096576;
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