## Foundry Merkle Airdrop Claim via Meta-Txn


**Interaction script commands**
1. Make use of deploy script under make
2. Call the `getMessageHash` function on the deployed `MerkleAirdrop` contract to generate the message hash to be signed by the user
   ```
   cast call 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512 "getMessageHash(address,uint)" 0x6CA6d1e2D5347Bfab1d91e883F1915560e09129D 10000000000000000000 --rpc-url http://localhost:8545
   ```
3. Sign the above generated message hash via the private key of the user to generate the signature
    ```
    cast wallet sign 0x30c45219c6ead623fdd4cc258e0c1f27d9aff54bd8e4c9f41f14631afde55c8e --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
    ```
4. Split the generated signature or put the generated signature under the `Interact.s.sol` file
5. Run the following command to execute the script on the anvil chain (made use of Anvil private key)
   ```
   forge script script/Interact.s.sol --rpc-url http://localhost:8545 --private-key 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d
   ```