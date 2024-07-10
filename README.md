## Foundry Merkle Airdrop Claim via Meta-Txn


**Interaction script commands**
1. Make use of deploy script under make
2. Call the `getMessageHash` function on the deployed `MerkleAirdrop` contract to generate the message hash to be signed by the user
   ```
   cast call 0xe7f1725e7734ce288f8367e1bb143e90bb3f0512 "getMessageHash(address,uint256)" 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 25000000000000000000 --rpc-url http://localhost:8545
   ```
3. Sign the above generated message hash via the private key of the user to generate the signature
    ```
    cast wallet sign 0x7886453564f3abce484240ab03353027bde591090caf1f82ce22c3487afe9568 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
    ```
4. Split the generated signature or put the generated signature under the `Interact.s.sol` file
5. Run the following command to execute the script on the anvil chain (made use of Anvil private key)
   ```
   forge script script/Interact.s.sol --rpc-url http://localhost:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
   ```