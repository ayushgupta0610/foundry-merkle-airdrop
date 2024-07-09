## Foundry Merkle Airdrop Claim via Meta-Txn


**Interaction script commands**
1. Make use of deploy script under make
2. Call the `getMessageHash` function on the deployed `MerkleAirdrop` contract to generate the message hash to be signed by the user
   ```
   cast call 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512 "getMessageHash(address,uint)" 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 25000000000000000000 --rpc-url http://localhost:8545
   ```
3. Sign the above generated message hash via the private key of the user to generate the signature
    ```
    cast wallet sign 0xb4227aaac5b633e2860fb75f6f679d7c8075b21613793e23b28ea5e8f2c37ce2 --private-key 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d
    ```
4. Split the generated signature or put the generated signature under the `Interact.s.sol` file
5. Run the following command to execute the script on the anvil chain (made use of Anvil private key)
   ```
   forge script script/Interact.s.sol --rpc-url http://localhost:8545 --private-key 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d
   ```