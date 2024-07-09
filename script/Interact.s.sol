// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Script} from "forge-std/Script.sol";
import {MerkleAirdrop} from "../src/MerkleAirdrop.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

contract Interact is Script {

    address private constant ACCOUNT = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    uint256 private constant AMOUNT = 12 ether;
    bytes32 private constant MERKLE_ROOT = 0xccb309293eed85a238c26406b58308e2846931836195702f5feb87a0000c0419;
    bytes32 private constant proofOne = 0x61798996101a3d9485268bfee4341d8e2ec44d9baa50cef242569f5a628519b9;
    bytes32 private constant proofTwo = 0x8aceb2bc486afcff8c556bdc8e44f21f32686822d57f25a4b33ca358a4a5dc45;
    bytes private SIGNATURE = hex"fa19c32433ff40d777ac2b9b340dc3aa736f1f905bde4dc824f9985319c1e1841b1e50e7555cafd2eb9bf37852364c2048080c918f484d2b27bef45af194c1e91c";

    bytes32[] private merkleProof = [proofOne, proofTwo];

    function splitSignature(bytes memory sig) public pure returns (uint8 v, bytes32 r, bytes32 s) {
        require(sig.length == 65, "invalid signature length");
        assembly {
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }
    }

    function claimAirdrop(address airdrop) public {
        vm.startBroadcast();
        (uint8 v, bytes32 r, bytes32 s) = splitSignature(SIGNATURE);
        MerkleAirdrop(airdrop).claim(ACCOUNT, AMOUNT, merkleProof, v, r, s);
        vm.stopBroadcast();
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("MerkleAirdrop", block.chainid);
        claimAirdrop(mostRecentlyDeployed);
    }
}