# Simple Storage (Starknet-js + Cairo)

In this tutorial, you will write and deploy a SimpleStorage Cairo contract on Starknet Sepolia Testnet. Then, you will learn how you can interact with the contract using Starknet-js. 

In order to fully understand and implement the content of this tutorial, here are the prerequisites:
- Basic knowledge of Cairo: you can get familiar with the Cairo language, and learn how to build a simple smart contract with Cairo [here](https://book.cairo-lang.org/).

- Scarb for compiling Cairo code and packaging support: follow [here](https://docs.swmansion.com/scarb/download.html).

- Starkli for the declaration and deployment of Cairo contracts: follow [here](https://book.starkli.rs/installation).

## Writing SimpleStorage contract in Cairo
The SimpleStorage contract has only one purpose: storing a number. We want the users to interact with the stored number by **viewing** the current stored number and **setting** a new number.

Let's create a Scarb package in order to write and compile the SimpleStorage contract. Make sure that Scarb is installed (installation link provided in the prerequisites):

```console
//move to the directory of your choice
$ scarb new simple_storage
```

With this command, a template for Cairo development environment is generated. Under the `src` directory, `lib.cairo` file is created. In order to start writing our contract, follow these steps: 
- Under the `src` directory, create a file named `storage.cairo` where we will write our contract.
- Delete the content of the `lib.cairo` file, and add `storage.cairo` as a module for the compilation of our Cairo contract: 
```rs
// Directory: src/lib.cairo 
mod storage;
```
- You can copy and paste the following Cairo code in `storage.cairo`. In this [link](https://book.cairo-lang.org/ch13-02-anatomy-of-a-simple-contract.html), you can find explanations for each component of the contract:

```rs
// Directory: src/storage.cairo 
#[starknet::interface]
trait ISimpleStorage<T> {
    fn set(ref self: T, x: u128);
    fn get(self: @T) -> u128;
}

#[starknet::contract]
mod SimpleStorage {
    #[storage]
    struct Storage {
        stored_data: u128
    }

    #[abi(embed_v0)]
    impl SimpleStorage of super::ISimpleStorage<ContractState> {
        fn set(ref self: ContractState, x: u128) {
            self.stored_data.write(x);
        }

        fn get(self: @ContractState) -> u128 {
            self.stored_data.read()
        }
    }
}
```
Because we want to interact with the get and set functions of the SimpleStorage contract using Starknet-js, we define the function signatures in `#[starknet::interface]`. The functions are defined under the macro `#[abi(embed_v0)]` where external functions are written.

Next, we need to update the dependencies of our Scarb folder. Open `Scarb.toml`, and add the following dependencies. These dependencies need to be added in order for our Cairo code to be deployed on Starknet as a smart contract.

```toml

[package]
name = "simple_storage"
version = "0.1.0"
edition = "2023_11"

# Add the dependencies below!

[dependencies]
starknet=">=2.4.1"

[[target.starknet-contract]]
```

Now, we have to compile our contract in order to declare and deploy on the Starknet Sepolia Testnet. Run the following command: 

```
$ scarb build
```

After you run the command, you should see a new folder called "target" in your your project folder. Your contract's Application Binary Interface (ABI) and Sierra program are found in that folder: `./target/simple_storage_SimpleStorage.contract_class.json`. We will need this file to interact with the contract using Starknet-js.

We are now ready to declare and deploy our contract on Starknet Sepolia Testnet!


## Declaring and Deploying the SimpleStorage contract
We will utilize Starkli in order to deploy and declare our smart contract on the Starknet Sepolia Testnet. Make sure that Starkli is installed in your device (check prerequisites above to find the link for Starkli installation). You can follow [this](https://medium.com/starknet-edu/starkli-the-new-starknet-cli-86ea914a2933) guide for Starkli or check out their documentation given above. 

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
Firstly, you need to declare your contract which will create a class on Starknet Sepolia. Note that we will use the Sierra program in `./target/simple_storage_SimpleStorage.contract_class.json`.

**Note:** The command below is written to run in the directory of the Scarb folder.

```console
$ starkli declare --keystore /path/to/starkli-wallet/keystore.json --account /path/to/starkli-wallet/account.json --watch ./target/dev/simple_storage_SimpleStorage.contract_class.json
```

After this command, the class hash is declared. You should be able to find the hash under the command: 
```console
Class hash declared:
0x05c8c21062a74e3c8f2015311d7431e820a08a6b0a9571422b607429112d2eb4
```

Now, it's time to deploy the contract. Add the clash hash after `--watch`: 
```console
$ starkli deploy --keystore /Users/egeaybars123/keystore/keystore --account /Users/egeaybars123/account/account.json --watch 0x05c8c21062a74e3c8f2015311d7431e820a08a6b0a9571422b607429112d2eb4
```
You should now see the address of the deployed contract. Note down the address of the contract; we will use it for interacting with the contract using Starknet-js.

## Interacting with SimpleStorage contract
We will interact with the SimpleStorage contract using Starknet-js. Firstly, create a new folder and inside the directory of the new folder, initialize the npm package (click Enter several items, you can skip adding the package info):

```console
$ npm init
```

Now, `package.json` file is created. Change the type of the package to a module. Add the line below in the object in `package.json`:

```json
"type": "module"
```

Let's add Starknet-js as a dependency:

```console
$ npm install starknet@next
```
Create a file named `index.js` where we will write JavaScript code to interact with our contract. Let's start our code by importing from Starknet-js, and from other libraries we will need:

```js
import { Account, RpcProvider, json, Contract } from 'starknet';
import fs from 'fs';
import * as dotenv from 'dotenv';
dotenv.config();
```

Let's create our provider object, and add our account address as a constant variable. We need the provider in order to send our queries and transactions to a Starknet node that is connected to the Starknet network: 

```js
const provider = new RpcProvider({ nodeUrl: 'https://starknet-sepolia.public.blastapi.io' });
const accountAddress = 'PASTE_ACCOUNT_ADDRESS_HERE';
```
The next step is creating an Account object that we will use to sign our transactions with our private key, so we need to import our private key. You can access your private key from your keystore with the following command using Starkli: 

```console
$ starkli signer keystore inspect-private /path/to/starkli-wallet/keystore.json --raw
```
Create a `.env` file in your project folder, and paste your private key as shown in the following line:
```bash
PRIVATE_KEY = "PASTE_PRIVATE_KEY_HERE"
```
**Note**: It is HIGHLY recommended to add `.gitignore`, and include your .env file there if you will be pushing your project to GitHub. Otherwise, your private key will be compromised.

Now, import your private key from the environment variables and create your Account object.

```js
const privateKey = process.env.PRIVATE_KEY;
// "1" is added to show that our account is deployed using Cairo 1.0.
const account = new Account(provider, accountAddress, privateKey, "1");
```

Now, let's create a Contract object in order to interact with our contract. In order to create the Contract object, we need the ABI and the address of our contract. The ABI contains information about what kind of data structures and functions there are in our contract so that we can interact with them using SDKs like Starknet-js. 

Create `abi.json` file in your folder, and copy & paste the contents of `./target/simple_storage_SimpleStorage.contract_class.json` in your Scarb folder. The beginning of the content of the ABI file should look like this: 

```json
{"sierra_program":["0x1","0x5","0x0","0x2","0x6","0x3","0x98","0x68","0x18","0x52616e6765436865636b","0x800000000000000100000000000000000000000000000000","0x436f6e7374","0x800000000000000000000000000000000000000000000002","0x1","0x16","0x2","0x53746f726555313238202d206e6f6e2075313238"}

...
```

By importing the content of the ABI and the address of the contract, create a Contract object: 
```js
//json parsing of the Starknet-js is used.
const compiledContractAbi = json.parse(
    fs.readFileSync('./abi.json').toString('ascii')
);
const contractAddress = 'PASTE_CONTRACT_ADDRESS_HERE';
const storageContract = new Contract(compiledContractAbi.abi, contractAddress, provider);
```

Now, we are good to go! By calling the `fn get(self: @ContractState) -> u128` function, we will be able to read the stored_data variable. Let's view the content of the stored_data using Starknet-js: 

```js
let getData = await storageContract.get();
console.log('Stored_data before set():', getData.toString());
```

Because our contract's ABI contains the information that such `get()` function exists in our contract, we can call that function using the Contract object.

In order to run your code, run the command `node index.js` in your project directory. After a short amount of time, you should see a "0" as the stored data. Let's set a new number to it!

```js
storageContract.connect(account);
```

Connecting your account to the contract is essential because we will use our account's private key to sign the transaction which will write to our stored_data variable.

```js
const myCall = storageContract.populate('set', [59]);
```
Then, construct the data which we will put in our transaction. The constructed data contains which function will be triggered with the provided argument. The function name is `set`, and the number we would like to store is 59; populate() function will create the data needed for our transaction. 

```js
const res = await storageContract.set(myCall.calldata);
```
In order to sign and broadcast the transaction, call our function `set` from the contract object (it can be called because it's in the ABI of our contract) by providing the calldata as an argument. 

The transaction is signed and broadcasted to the network now. It takes a few seconds for the transaction to be confirmed.

```js
await provider.waitForTransaction(res.transaction_hash);
```
The line above will wait for the transaction to be confirmed. It is required to wait for the confirmation in order to see the new number in the stored_data variable. Let's add another code snippet to view the stored number after the transaction:

```js
getData = await storageContract.get();
console.log('Stored_data after set():', getData.toString());
```

Let's run our code with `node index.js`, and see what happens in the terminal: 

```console
Stored_data before set(): 0
Stored_data after set(): 59
```

Congrats! You have written your contract, deployed it and interacted with it using Starknet-js! 
