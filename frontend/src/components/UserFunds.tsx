import { formatEther } from "viem";
import {
  useAccount,
  useWaitForTransactionReceipt,
  useWriteContract,
} from "wagmi";
import { rockPaperScissorsContract } from "~/contracts/RockPaperScissors";

interface UserFundsProps {
  balanceResult: bigint | undefined;
  refetchBalance: () => void;
}

export default function UserFunds({
  balanceResult,
  refetchBalance,
}: UserFundsProps) {
  const account = useAccount();
  const {
    data: hashWithdraw,
    isPending: withdrawPending,
    writeContract,
  } = useWriteContract({
    mutation: {
      onSuccess: () => {
        refetchBalance();
      },
    },
  });

  const {
    isLoading: isWithdrawing,
    isSuccess: isSuccessWithdraw,
    error: errorWithdraw,
  } = useWaitForTransactionReceipt({
    hash: hashWithdraw,
  });

  const onClickWithdraw = () => {
    writeContract(
      {
        ...rockPaperScissorsContract,
        functionName: "withdraw",
      },
      {
        onError: (error) => {
          console.error(error.message);
        },
      },
    );
  };

  return (
    <div className="flex items-center justify-center">
      <span className="text-lg font-bold">
        {balanceResult !== undefined ? formatEther(balanceResult) : "0"} {"ETH"}
      </span>
      {balanceResult && balanceResult > BigInt(0) ? (
        <button
          onClick={onClickWithdraw}
          disabled={!account.isConnected || isWithdrawing || withdrawPending}
          className="ml-3 rounded-xl bg-gray-600 px-3 py-1 font-bold"
        >
          Withdraw
        </button>
      ) : null}
      {isWithdrawing && (
        <span className="ml-3 text-lg">Confirming receipt...</span>
      )}
      {isSuccessWithdraw && (
        <span className="ml-3 text-lg text-green-400">Success</span>
      )}
      {errorWithdraw && (
        <span className="ml-3 text-lg text-red-500">
          {errorWithdraw.message}
        </span>
      )}
    </div>
  );
}
