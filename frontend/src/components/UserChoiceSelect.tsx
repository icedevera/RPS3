import { type Dispatch, type SetStateAction } from "react";
import { cn } from "~/utils/cn";
import { EMOJIS, type Choice } from "~/utils/rockPaperScissors";

interface ChoiceButtonProps {
  choice: Choice;
  userChoice: Choice | null;
  setUserChoice: Dispatch<SetStateAction<Choice | null>>;
  disabled: boolean;
}

const ChoiceButton = ({
  choice,
  userChoice,
  setUserChoice,
  disabled,
}: ChoiceButtonProps) => {
  return (
    <button
      className={cn(
        "flex h-64 w-64 cursor-pointer items-center justify-center rounded-lg border-2 text-8xl transition-all hover:bg-[#66fff7] hover:text-9xl",
        userChoice === choice && "bg-[#66a8ff] text-9xl",
      )}
      onClick={() =>
        userChoice === choice ? setUserChoice(null) : setUserChoice(choice)
      }
      disabled={disabled}
      aria-label={choice}
    >
      {EMOJIS[choice]}
    </button>
  );
};

interface UserChoiceSelectProps {
  userChoice: Choice | null;
  setUserChoice: Dispatch<SetStateAction<Choice | null>>;
  opponentChoice: Choice | null;
}

export default function UserChoiceSelect({
  userChoice,
  setUserChoice,
  opponentChoice,
}: UserChoiceSelectProps) {
  return (
    <div className="flex w-full justify-center gap-12 pb-10">
      <ChoiceButton
        choice="rock"
        userChoice={userChoice}
        setUserChoice={setUserChoice}
        disabled={!!opponentChoice}
      />
      <ChoiceButton
        choice="paper"
        userChoice={userChoice}
        setUserChoice={setUserChoice}
        disabled={!!opponentChoice}
      />
      <ChoiceButton
        choice="scissors"
        userChoice={userChoice}
        setUserChoice={setUserChoice}
        disabled={!!opponentChoice}
      />
    </div>
  );
}
