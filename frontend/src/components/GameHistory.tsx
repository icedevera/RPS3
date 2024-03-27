import React, { cloneElement } from "react";

export interface GameStatus {
  fees: bigint;
  player: string;
  outcome: 0 | 1 | 2 | 3;
  playerChoice: 0 | 1 | 2;
}

const intersperse = (
  array: React.ReactNode[],
  separator: React.ReactElement,
) => {
  return array.reduce<React.ReactNode[]>((acc, elem, index) => {
    const separatorKey = `separator-${index}`;
    if (index === 0) {
      return [elem];
    } else {
      return [...acc, cloneElement(separator, { key: separatorKey }), elem];
    }
  }, []);
};

interface GameHistoryProps {
  gameHistoryResult: GameStatus[] | undefined;
}

export default function GameHistory({ gameHistoryResult }: GameHistoryProps) {
  if (!gameHistoryResult) {
    return (
      <>
        <span className="pt-2 text-sm">Game History (Latest to Oldest):</span>
        <div>
          <span className="text-lg text-gray-500">No games yet</span>
        </div>
      </>
    );
  }

  const outcomes = gameHistoryResult.map((game, i) => {
    const key = `${game.player.toString()}-${game.fees.toString()}-${game.outcome.toString()}-${i}`;

    return <GameResult key={key} outcome={game.outcome} />;
  });

  const reversedOutcomes = outcomes.reverse();
  const separatedOutcomes = intersperse(
    reversedOutcomes,
    <span className="text-lg">, </span>,
  );

  return (
    <>
      <span className="pt-2 text-sm">Game History (Latest to Oldest): </span>
      <div>
        <span>
          {separatedOutcomes.length ? (
            separatedOutcomes
          ) : (
            <span className="text-lg text-gray-500">No games yet</span>
          )}
        </span>
      </div>
    </>
  );
}

const GameResult = ({ outcome }: { outcome: 0 | 1 | 2 | 3 }) => {
  if (outcome === 0) {
    return <span className="text-lg">None</span>;
  }
  if (outcome === 1) {
    return <span className="text-lg text-green-500">Win</span>;
  }
  if (outcome === 2) {
    return <span className="text-lg text-red-500">Lose</span>;
  }
  return <span className="text-lg text-gray-500">Draw</span>;
};
