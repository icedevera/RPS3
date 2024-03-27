"use client";

import { ConnectButton } from "@rainbow-me/rainbowkit";
import { useState } from "react";
import "@rainbow-me/rainbowkit/styles.css";
import {
  useAccount,
  useReadContract,
  useWaitForTransactionReceipt,
  useWatchContractEvent,
  useWriteContract,
} from "wagmi";
import { rockPaperScissorsContract } from "~/contracts/RockPaperScissors";
import { parseEther } from "viem";
import GameHistory, { type GameStatus } from "~/components/GameHistory";
import LoadingState from "~/components/LoadingState";
import Result from "~/components/Result";
import UserChoiceSelect from "~/components/UserChoiceSelect";
import UserFunds from "~/components/UserFunds";
import {
  EMOJIS,
  choiceToNumber,
  outcomeToComputerChoice,
  type Choice,
} from "~/utils/rockPaperScissors";
import LatestRequestId from "~/components/LatestRequestId";

export default function HomePage() {
  const account = useAccount();

  const [userChoice, setUserChoice] = useState<Choice | null>(null);
  const [opponentChoice, setOpponentChoice] = useState<Choice | null>(null);

  const { data: gameHistoryData, refetch: refetchGameHistory } =
    useReadContract({
      ...rockPaperScissorsContract,
      functionName: "getGameHistory",
      account: account.address,
      query: {
        enabled: account.isConnected,
      },
    });

  const gameHistoryResult = gameHistoryData as GameStatus[] | undefined;

  const { data: balanceResult, refetch: refetchBalance } = useReadContract({
    ...rockPaperScissorsContract,
    functionName: "balances",
    account: account.address,
    args: [account.address!],
    query: {
      enabled: account.isConnected,
    },
  });

  const { data: lastRequestIdResult, refetch: refetchLastRequestId } =
    useReadContract({
      ...rockPaperScissorsContract,
      functionName: "lastRequestId",
      account: account.address,
      args: [account.address!],
      query: {
        enabled: account.isConnected,
      },
    });

  const {
    data: hash,
    isPending,
    writeContract,
    reset,
  } = useWriteContract({
    mutation: {
      onSuccess: () => {
        void refetchLastRequestId();
      },
    },
  });

  useWatchContractEvent({
    ...rockPaperScissorsContract,
    eventName: "PlayGameResult",
    args: {
      player: account.address,
      requestId: lastRequestIdResult,
    },
    onLogs(logs) {
      if (!userChoice) return;

      const outcome = logs[0]?.args.outcome;

      if (!outcome) return;

      const computerChoice = outcomeToComputerChoice(
        outcome as 0 | 1 | 2 | 3,
        userChoice,
      );

      setOpponentChoice(computerChoice);
      void refetchGameHistory();
      void refetchBalance();
    },
    onError(error) {
      console.error(error.message);
    },
    enabled: account.isConnected && !!account.address && !!lastRequestIdResult,
  });

  const {
    isLoading: isConfirming,
    isSuccess: isConfirmed,
    error,
  } = useWaitForTransactionReceipt({
    hash,
  });

  const onClickPlay = () => {
    if (!userChoice) {
      return;
    }

    writeContract({
      ...rockPaperScissorsContract,
      functionName: "playGame",
      args: [choiceToNumber(userChoice)],
      value: parseEther("0.001"),
    });
  };

  const onReset = () => {
    setOpponentChoice(null);
    setUserChoice(null);
    reset();
  };

  return (
    <main className="flex min-h-screen flex-col items-center bg-gradient-to-b from-[#02246d] to-[#15162c] text-white">
      <div className="container flex flex-col items-center justify-center gap-12 px-4 py-8 ">
        <h1 className="text-5xl font-extrabold tracking-tight text-white sm:text-[5rem]">
          RPS<span className="text-[#66fff7]">3</span>
        </h1>
      </div>

      <UserFunds
        balanceResult={balanceResult}
        refetchBalance={() => void refetchBalance()}
      />

      <div className="flex justify-end px-12 py-8">
        <ConnectButton />
      </div>

      <UserChoiceSelect
        userChoice={userChoice}
        setUserChoice={setUserChoice}
        opponentChoice={opponentChoice}
      />

      <div className="pb-10">
        {opponentChoice ? (
          <button
            onClick={onReset}
            disabled={!account.isConnected || isPending}
            className="rounded-lg bg-[#ffffff] px-10 py-3 text-4xl font-extrabold text-gray-800"
          >
            RESET
          </button>
        ) : (
          <button
            onClick={onClickPlay}
            disabled={!account.isConnected || isPending}
            className="rounded-lg bg-[#ffffff] px-10 py-3 text-4xl font-extrabold text-gray-800"
          >
            {isPending ? "Confirming..." : "PLAY"}
          </button>
        )}
      </div>

      <div className="grid grid-cols-2 gap-4 px-16 py-6">
        <div className="flex w-96 flex-col p-4">
          <h3 className="text-center text-xl font-bold text-[#66fff7]">DATA</h3>

          <LatestRequestId lastRequestIdResult={lastRequestIdResult} />
          <GameHistory gameHistoryResult={gameHistoryResult} />
        </div>

        <div className="flex h-96 w-96 flex-col items-center rounded-lg border-2 border-solid border-white p-4">
          <h3 className="pb-2 text-center text-xl font-bold text-[#66fff7]">
            OUTCOME
          </h3>

          <LoadingState
            error={error}
            isConfirmed={isConfirmed}
            isConfirming={isConfirming}
            opponentChoice={opponentChoice}
          />

          {opponentChoice && (
            <>
              <div className="pb-4">
                <div className="flex h-64 w-64 items-center justify-center rounded-lg border-2 bg-[#fc7b7b] text-8xl transition-all">
                  {EMOJIS[opponentChoice]}
                </div>
              </div>
              <Result userChoice={userChoice} opponentChoice={opponentChoice} />
            </>
          )}
        </div>
      </div>
    </main>
  );
}
