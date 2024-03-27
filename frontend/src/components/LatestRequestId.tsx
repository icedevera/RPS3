interface LatestRequestIdProps {
  lastRequestIdResult: bigint | undefined;
}

export default function LatestRequestId({
  lastRequestIdResult,
}: LatestRequestIdProps) {
  return (
    <>
      <span className="text-sm">Latest Request ID: </span>
      <span className="max-w-full break-words backdrop:text-lg">
        {lastRequestIdResult !== undefined && lastRequestIdResult !== BigInt(0)
          ? lastRequestIdResult.toString()
          : "N/A"}
      </span>
    </>
  );
}
