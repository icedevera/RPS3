import { FidgetSpinner } from "react-loader-spinner";
import type { WaitForTransactionReceiptErrorType } from "viem";
import { type Choice } from "~/utils/rockPaperScissors";

interface LoadingStateProps {
  isConfirming: boolean;
  isConfirmed: boolean;
  opponentChoice: Choice | null;
  error: WaitForTransactionReceiptErrorType | null;
}

export default function LoadingState({
  isConfirmed,
  isConfirming,
  opponentChoice,
  error,
}: LoadingStateProps) {
  if (isConfirming) {
    return (
      <>
        <span className="pt-2 text-center text-2xl text-gray-400">
          Waiting for confirmation...
        </span>
        <Spinner />
      </>
    );
  }

  if (isConfirmed && !opponentChoice) {
    return (
      <>
        <span className="pt-2 text-center text-2xl text-green-400">
          You&apos;re in! Waiting for outcome...
        </span>
        <Spinner />
      </>
    );
  }

  if (error) {
    return <span className="p-6 text-sm text-red-500">{error.message}</span>;
  }

  return null;
}

function Spinner() {
  return (
    <div className="pt-4">
      <FidgetSpinner
        visible={true}
        height="200"
        width="200"
        ariaLabel="fidget-spinner-loading"
        wrapperStyle={{}}
        wrapperClass="fidget-spinner-wrapper"
        backgroundColor="#fff"
      />
    </div>
  );
}
