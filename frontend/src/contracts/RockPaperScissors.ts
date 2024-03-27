import { env } from "~/env";

export const rockPaperScissorsAbi = [
  {
    type: "constructor",
    inputs: [
      {
        name: "linkAddress",
        type: "address",
        internalType: "address",
      },
      {
        name: "vrfWrapperAddress",
        type: "address",
        internalType: "address",
      },
    ],
    stateMutability: "payable",
  },
  {
    type: "receive",
    stateMutability: "payable",
  },
  {
    type: "function",
    name: "balances",
    inputs: [
      {
        name: "",
        type: "address",
        internalType: "address",
      },
    ],
    outputs: [
      {
        name: "",
        type: "uint256",
        internalType: "uint256",
      },
    ],
    stateMutability: "view",
  },
  {
    type: "function",
    name: "getGameHistory",
    inputs: [],
    outputs: [
      {
        name: "",
        type: "tuple[]",
        internalType: "struct RockPaperScissors.GameStatus[]",
        components: [
          {
            name: "fees",
            type: "uint256",
            internalType: "uint256",
          },
          {
            name: "player",
            type: "address",
            internalType: "address",
          },
          {
            name: "outcome",
            type: "uint8",
            internalType: "enum RockPaperScissors.Outcome",
          },
          {
            name: "playerChoice",
            type: "uint8",
            internalType: "enum RockPaperScissors.Choice",
          },
        ],
      },
    ],
    stateMutability: "view",
  },
  {
    type: "function",
    name: "lastRequestId",
    inputs: [
      {
        name: "",
        type: "address",
        internalType: "address",
      },
    ],
    outputs: [
      {
        name: "",
        type: "uint256",
        internalType: "uint256",
      },
    ],
    stateMutability: "view",
  },
  {
    type: "function",
    name: "playGame",
    inputs: [
      {
        name: "choice",
        type: "uint8",
        internalType: "enum RockPaperScissors.Choice",
      },
    ],
    outputs: [
      {
        name: "",
        type: "uint256",
        internalType: "uint256",
      },
    ],
    stateMutability: "payable",
  },
  {
    type: "function",
    name: "rawFulfillRandomWords",
    inputs: [
      {
        name: "_requestId",
        type: "uint256",
        internalType: "uint256",
      },
      {
        name: "_randomWords",
        type: "uint256[]",
        internalType: "uint256[]",
      },
    ],
    outputs: [],
    stateMutability: "nonpayable",
  },
  {
    type: "function",
    name: "statuses",
    inputs: [
      {
        name: "",
        type: "uint256",
        internalType: "uint256",
      },
    ],
    outputs: [
      {
        name: "fees",
        type: "uint256",
        internalType: "uint256",
      },
      {
        name: "player",
        type: "address",
        internalType: "address",
      },
      {
        name: "outcome",
        type: "uint8",
        internalType: "enum RockPaperScissors.Outcome",
      },
      {
        name: "playerChoice",
        type: "uint8",
        internalType: "enum RockPaperScissors.Choice",
      },
    ],
    stateMutability: "view",
  },
  {
    type: "function",
    name: "withdraw",
    inputs: [],
    outputs: [],
    stateMutability: "nonpayable",
  },
  {
    type: "event",
    name: "PlayGameRequest",
    inputs: [
      {
        name: "requestId",
        type: "uint256",
        indexed: true,
        internalType: "uint256",
      },
      {
        name: "player",
        type: "address",
        indexed: true,
        internalType: "address",
      },
    ],
    anonymous: false,
  },
  {
    type: "event",
    name: "PlayGameResult",
    inputs: [
      {
        name: "requestId",
        type: "uint256",
        indexed: true,
        internalType: "uint256",
      },
      {
        name: "player",
        type: "address",
        indexed: true,
        internalType: "address",
      },
      {
        name: "outcome",
        type: "uint8",
        indexed: false,
        internalType: "enum RockPaperScissors.Outcome",
      },
    ],
    anonymous: false,
  },
  {
    type: "event",
    name: "Withdraw",
    inputs: [
      {
        name: "player",
        type: "address",
        indexed: true,
        internalType: "address",
      },
      {
        name: "amount",
        type: "uint256",
        indexed: false,
        internalType: "uint256",
      },
    ],
    anonymous: false,
  },
] as const;

export const rockPaperScissorsContract = {
  address:
    env.NEXT_PUBLIC_NETWORK === "sepolia"
      ? (env.NEXT_PUBLIC_ROCK_PAPER_SCISSORS_ADDRESS as `0x${string}`)
      : (env.NEXT_PUBLIC_LOCAL_ROCK_PAPER_SCISSORS_ADDRESS as `0x${string}`),
  abi: rockPaperScissorsAbi,
};
