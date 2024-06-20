## Declaring and Deploying Your Contract
We will utilize Starkli in order to deploy and declare our smart contracts on Starknet. Make sure that Starkli is installed in your device. You can follow [this](https://github.com/xJonathanLEI/starkli) repository for Starkli or check out their [docs](https://book.starkli.rs/). 

For this tutorial, we will create a new account. If you already have an account, you can skip this step and move to the part where we declare our contract.

### Creating a new account:
You should move to the directory where you want to access your account keystores, and then create a new folder for the wallet.
```console
$ mkdir ./starkli-wallet
```

Create a new signer. You will be instructed to enter a password to encrypt your private key: 
```console
$ starkli signer keystore new ./starkli-wallet/keystore.json
```
After this command, the path of the encrypted keystore file is shown which will be needed during the declaration and deployment of the contract. 

Export the keystore path in order not to call --keystore in every command:
```console
$ export STARKNET_KEYSTORE="./starkli-wallet/keystore.json"
```
Initialize the account with the following command using OpenZeppelin's class deployed on Starknet.

```console
$ starkli account oz init ./starkli-wallet/account.json
```
After this command, the address of the account is shown once it is deployed along with the deploy command. Deploy the account: 
```console
$ starkli account deploy ./starkli-wallet/account.json
```
This command wants you to fund the address (given in the instructions below the command) in order to deploy the account on the Starknet Sepolia Testnet. We need testnet Ether on Starknet Sepolia which could be obtained from [this](https://starknet-faucet.vercel.app/) testnet faucet. Once the transaction is confirmed on the faucet page, click ENTER on the command line, and the account will be deployed on Starknet Sepolia! Find your account on the [Voyager Sepolia block explorer](https://sepolia.voyager.online/).

### Declaring & Deploying your Contract:
Firstly, you need to declare your contract which will create a class on Starknet Sepolia. Note that we will use the Sierra program in `./target/ProjectName_ContractName.contract_class.json` in your Scarb folder.

**Note:** The command below is written to run in the directory of the Scarb folder.

```console
$ starkli declare --keystore /path/to/starkli-wallet/keystore.json --account /path/to/starkli-wallet/account.json --watch ./target/dev/simple_storage_SimpleStorage.contract_class.json
```

After this command, the class hash for your contract is declared. You should be able to find the hash under the command: 
```console
Class hash declared:
0x05c8c21062a74e3c8f2015311d7431e820a08a6b0a9571422b607429112d2eb4
```

Now, it's time to deploy the contract. Add the clash hash given above after `--watch`: 
```console
$ starkli deploy --keystore /Users/egeaybars123/keystore/keystore --account /Users/egeaybars123/account/account.json --watch 0x05c8c21062a74e3c8f2015311d7431e820a08a6b0a9571422b607429112d2eb4
```
You should now see the address of the deployed contract. Congratulations, you have deployed your contract on Starknet Sepolia Testnet!