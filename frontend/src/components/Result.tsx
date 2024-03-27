import { calculateOutcome, type Choice } from "~/utils/rockPaperScissors";

interface ResultProps {
  userChoice: Choice | null;
  opponentChoice: Choice | null;
}

export default function Result({ userChoice, opponentChoice }: ResultProps) {
  if (!userChoice || !opponentChoice) {
    return null;
  }

  const outcome = calculateOutcome(userChoice, opponentChoice);

  if (outcome === "DRAW") {
    return (
      <span className="text-center text-5xl font-extrabold text-gray-500">
        DRAW 🤝
      </span>
    );
  }

  if (outcome === "WIN") {
    return (
      <span className="text-center text-5xl font-extrabold text-green-500">
        WIN 🎉
      </span>
    );
  }

  return (
    <span className="text-center text-5xl font-extrabold text-red-500">
      LOSE 💀
    </span>
  );
}
