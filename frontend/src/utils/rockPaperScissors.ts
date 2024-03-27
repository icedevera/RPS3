export const CHOICES = ["rock", "paper", "scissors"] as const;
export type Choice = (typeof CHOICES)[number];

export const EMOJIS = {
  rock: "🪨",
  paper: "📃",
  scissors: "✂️",
} as const;

export const choiceToNumber = (choice: Choice) => {
  switch (choice) {
    case "rock":
      return 0;
    case "paper":
      return 1;
    case "scissors":
      return 2;
  }
};

export const outcomeToComputerChoice = (
  outcome: 0 | 1 | 2 | 3,
  playerChoice: Choice,
) => {
  if (outcome === 1) {
    switch (playerChoice) {
      case "rock":
        return "scissors";
      case "paper":
        return "rock";
      case "scissors":
        return "paper";
    }
  }

  if (outcome === 2) {
    //player lost
    switch (playerChoice) {
      case "rock":
        return "paper";
      case "paper":
        return "scissors";
      case "scissors":
        return "rock";
    }
  }

  return playerChoice;
};

export const calculateOutcome = (
  userChoice: Choice | null,
  opponentChoice: Choice | null,
): "DRAW" | "WIN" | "LOSE" => {
  if (userChoice === opponentChoice) {
    return "DRAW";
  }

  if (
    (userChoice === "rock" && opponentChoice === "scissors") ||
    (userChoice === "paper" && opponentChoice === "rock") ||
    (userChoice === "scissors" && opponentChoice === "paper")
  ) {
    return "WIN";
  }

  return "LOSE";
};
