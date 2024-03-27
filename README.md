# RPS3

A simple rock paper scissors game decentralized with Chainlink VRF.

_Built as a learning project in the Crypto Academy of Vacuumlabs._

## Project Structure

```text
foundry
  └─ backend eth smart contracts
frontend
  └─ next.js frontend
```

## Developing locally (local blockchain)

1. Copy example env for both the /foundry and /frontend directories.

```bash
$ cp ./foundry/.env.example ./foundry/.env
$ cp ./frontend/.env.example ./frontend/.env
```

2. (in a separate terminal) Start NextJS development.

```bash
$ cd frontend
$ yarn install
$ yarn dev
```

3. (in a separate terminal) run a local blockchain using anvil. Take note of a private key add it to the /foundry `.env` as `LOCAL_DEV_ANVIL_PRIVATE_KEY` and import it using Metamask or a wallet of your choice.

```bash
$ anvil
```

4. Run the `LocalDeployment` script as seen on the `/foundry` README. This will also output some addresses that needs to be placed in their respective `.env`:

`/foundry` env vars:

- `LOCAL_DEV_VRF_COORDINATOR_V2_MOCK_ADDRESS`
- `LOCAL_DEV_VRF_V2_WRAPPER_ADDRESS`
- `LOCAL_DEV_ROCK_PAPER_SCISSORS_ADDRESS`

`/frontend` env vars:

- `NEXT_PUBLIC_NETWORK` - set to `hardhat`
- `NEXT_PUBLIC_LOCAL_ROCK_PAPER_SCISSORS_ADDRESS`

```bash
$ cd foundry
$ forge script script/LocalDeployment.s.sol:LocalDeploymentScript --rpc-url "http://127.0.0.1:8545" --broadcast -vvvv
```

5. Fund the address you'll use to play the game by adding your wallet of choice to the /foundry `.env` as `LOCAL_DEV_ADDRESS`. Once added you can run this command:

```bash
$ forge script script/SendEtherLocal.s.sol:SendEtherLocalScript --rpc-url "http://127.0.0.1:8545" --broadcast -vvvv
```

6. Open http://localhost:3000 to view the frontend UI, and connect your wallet with the account you just funded.

7. Select a choice and play the game. Be sure to change the Gas limit in your wallet to `500000` since estimations aren't so accurate for local developoment.

8. Once `playGame` transaction is confirmed and `lastRequestId` is updated, run the `FulfillRandomWords` script as seen on the /foundry README. Be sure to update the `LOCAL_DEV_REQUEST_ID` to the `lastRequestId` value.

```bash
$ cd foundry
$ forge script script/FullfillRandomWords.s.sol:FullfillRandomWordsScript --rpc-url "http://127.0.0.1:8545" --broadcast -vvvv --skip-simulation --gas-estimate-multiplier 500
```

9. If you Won or Draw, you'll be able to withdraw your balance by clicking the Withdraw button.
