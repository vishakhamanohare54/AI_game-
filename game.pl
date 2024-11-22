% Start the game
start :-
    writeln('Welcome to Rock-Paper-Scissors with AI!'),
    writeln('Player 1 will play against the AI.'),
    play.

% Main game loop
play :-
    % Get choice from Player 1
    get_player_choice(1, PlayerChoice),
    % AI chooses using Minimax algorithm with Alpha-Beta Pruning
    ai_choice(PlayerChoice, AIChoice),
    % Determine the winner
    determine_winner(PlayerChoice, AIChoice, Winner),
    % Display result
    display_result(PlayerChoice, AIChoice, Winner),
    % Ask to play again
    play_again.

% Get a player's choice
get_player_choice(Player, Choice) :-
    format('Player ~w, enter your choice (rock/paper/scissors): ', [Player]),
    read(Choice),
    validate_choice(Choice).
% Validate the choice
validate_choice(rock).
validate_choice(paper).
validate_choice(scissors).
validate_choice(Choice) :-
    \+ member(Choice, [rock, paper, scissors]),
    writeln('Invalid choice, try again.'),
    fail.

% AI chooses using Minimax with Alpha-Beta pruning
ai_choice(PlayerChoice, AIChoice) :-
    minimax(PlayerChoice, [rock, paper, scissors], -inf, inf, AIChoice, _).

% Minimax algorithm with Alpha-Beta pruning
minimax(_, [Move], _, _, Move, 0).  % Base case: only one move left
minimax(PlayerChoice, [Move|Moves], Alpha, Beta, BestMove, BestScore) :-
    % Evaluate current move
    evaluate(PlayerChoice, Move, Score),
    % Update Alpha and Beta
    NewAlpha is max(Alpha, Score),
    NewBeta is min(Beta, Score),
    % Prune if Alpha >= Beta
    (NewAlpha >= NewBeta ->
        BestMove = Move,
        BestScore = Score
    ; % Recursively check the rest of the moves
        minimax(PlayerChoice, Moves, NewAlpha, NewBeta, NextBestMove, NextBestScore),
 (Score > NextBestScore ->
            BestMove = Move,
            BestScore = Score
        ;
            BestMove = NextBestMove,
            BestScore = NextBestScore
        )
    ).

% Evaluation function for AI's choice
evaluate(rock, rock, 0).       % Draw
evaluate(rock, paper, 1).      % AI wins
evaluate(rock, scissors, -1).  % Player wins
evaluate(paper, rock, -1).
evaluate(paper, paper, 0).
evaluate(paper, scissors, 1).
evaluate(scissors, rock, 1).
evaluate(scissors, paper, -1).
evaluate(scissors, scissors, 0).

% Determine the winner
determine_winner(Choice1, Choice2, 0) :- Choice1 = Choice2.
determine_winner(rock, scissors, 1).
determine_winner(scissors, paper, 1).
determine_winner(paper, rock, 1).
determine_winner(rock, paper, 2).
determine_winner(scissors, rock, 2).
determine_winner(paper, scissors, 2).
% Display the result
display_result(Choice1, Choice2, 0) :-
    format('Player chose ~w. AI chose ~w. It\'s a draw!~n', [Choice1, Choice2]).
display_result(Choice1, Choice2, 1) :-
    format('Player chose ~w. AI chose ~w. Player wins!~n', [Choice1, Choice2]).
display_result(Choice1, Choice2, 2) :-
    format('Player chose ~w. AI chose ~w. AI wins!~n', [Choice1, Choice2]).

% Ask if players want to play again
play_again :-
    writeln('Do you want to play again? (yes/no): '),
    read(Response),
    ( Response == yes ->
        play
    ; writeln('Thanks for playing!')
    ).
