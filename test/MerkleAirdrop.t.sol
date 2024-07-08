// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Test} from "forge-std/Test.sol";
import {MerkleAirdrop} from "../src/MerkleAirdrop.sol";
import {CoffeeToken} from "../src/CoffeeToken.sol";

contract MerkleAirdropTest is Test {

    MerkleAirdrop private merkleAirdrop;
    CoffeeToken private coffeeToken;
    address private user;
    uint256 private userKey;

    uint256 public constant AMOUNT = 10 ether;
    bytes32 public constant MERKLE_ROOT = 0xccb309293eed85a238c26406b58308e2846931836195702f5feb87a0000c0419;
    bytes32 proofOne = 0x50307774e64ddd9e65a8ffe90976869c1f52c4a27bad56f4e383c530d6b75217;
    bytes32 proofTwo = 0x8aceb2bc486afcff8c556bdc8e44f21f32686822d57f25a4b33ca358a4a5dc45;
    bytes32[] public MERKLE_PROOF = [proofOne, proofTwo];

    function setUp() public {
        coffeeToken = new CoffeeToken();
        merkleAirdrop = new MerkleAirdrop(MERKLE_ROOT, coffeeToken);
        coffeeToken.mint(address(merkleAirdrop), AMOUNT);
        (user, userKey) = makeAddrAndKey("user");
    }


    function testClaim() public {
        vm.prank(user);
        merkleAirdrop.claim(user, AMOUNT, MERKLE_PROOF);
        assertEq(coffeeToken.balanceOf(user), AMOUNT);
    }

}