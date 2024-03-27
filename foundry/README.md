## Rock Paper Scissors

**Provably random rock paper scissors game using Chainlink VRF**

## Run Locally

1. Copy example env and fill it up with the necessary details for the network.

```bash
cp .env.example .env
```

2. (In a separate terminal) Run anvil to start a local blockchain.

```bash
anvil
```

3. Take note of a private key from the output of running anvil and place it into the env as `LOCAL_DEV_ANVIL_PRIVATE_KEY`.

4. (If using the frontend) Fund Local Dev Address. Add the wallet address you'll use for local testing to env as `LOCAL_DEV_ADDRESS` and run command to fund account with some ETH.

```bash
$ forge script script/SendEtherLocal.s.sol:SendEtherLocalScript --rpc-url "http://127.0.0.1:8545" --broadcast -vvvv
```

5. (If not using the frontend) use an anvil address for the `LOCAL_DEV_ADDRESS`.

6. Run the local deployment script.

```bash
$ forge script script/LocalDeployment.s.sol:LocalDeploymentScript --rpc-url "http://127.0.0.1:8545" --broadcast -vvvv
```

7. Play the game by either using the frontend interface or running this script. Take note of the outputted `requestId` as this will be needed for checking the status.

```bash
$ forge script script/PlayGame.s.sol:PlayGameScript --rpc-url "http://127.0.0.1:8545" --broadcast -vvvv
```

8. Once the game is played, you can call the `fulfillRandomWords` function from the `VRFCoordinatorV2Mock` to get the randomness request fulfilled. Be sure to add following env variables to .env:

- `LOCAL_DEV_VRF_COORDINATOR_V2_MOCK_ADDRESS`
- `LOCAL_DEV_VRF_V2_WRAPPER_ADDRESS`
- `LOCAL_DEV_REQUEST_ID` - Used for identifying requests for the `FulfillRandomWords` script. If using the frontend, this value is shown in the front end as "Latest Request Id" and is updated when playing the game. If using the `playGame` script this will be outputted in the console.

```bash
$ forge script script/FullfillRandomWords.s.sol:FullfillRandomWordsScript --rpc-url "http://127.0.0.1:8545" --broadcast -vvvv --skip-simulation --gas-estimate-multiplier 500
```

9. (If ran the playGame script) Check the status of the request until an outcome is determined. Be sure to add `LOCAL_DEV_ROCK_PAPER_SCISSORS_ADDRESS` to env.

```bash
$ forge script script/LocalStatus.s.sol:LocalStatusScript --rpc-url "http://127.0.0.1:8545" --broadcast -vvvv
```

## Deploy to network

\*\*Note: Make sure you have enough ETH in the deploying account. The script deploys the contract with a value of 1 ETH.

1. Copy example env and fill it up with the necessary details for the network.

```bash
cp .env.example .env
```

2. (Optional) simulate the deployment by ommitting the --broadcast flag.

```bash
$ forge script script/RockPaperScissors.s.sol:RockPaperScissorsScript --rpc-url $<rpc_url_env_variable>
```

3. Run the following to deploy. Note that --verify requires the ETHERSCAN_API_KEY to be set.

```bash
$ forge script script/RockPaperScissors.s.sol:RockPaperScissorsScript --rpc-url $<rpc_url_env_variable> --broadcast --verify -vvvv
```

## Generating ABI

In order to generate the ABI, run the following command in ther terimanl which will output the `RockPaperScissors.sol` ABI:

```bash
$ forge build --silent && jq '.abi' ./out/RockPaperScissors.sol/RockPaperScissors.json
```

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
