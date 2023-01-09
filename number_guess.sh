#!/bin/bash
# Guessing number game
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
RANDOM_NUM=$((1+$RANDOM%1000))

echo "Enter your username:"
read USERNAME

GET_USERNAME=$($PSQL "SELECT username FROM users WHERE username='$USERNAME'")
# check if is null
if [[ -z $USERNAME ]]
then
  echo "Introduce a name."
  exit 0
elif [[ -z $GET_USERNAME ]]
then
  echo -e "\nWelcome, $USERNAME! It looks like is your first time here."
  INSERT_NEW_USER=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
  GET_USERNAME=$($PSQL "SELECT username FROM users WHERE username='$USERNAME'")
  GET_BEST_GAME=0
  GET_GAMES_PLAYED=0
else
  GET_BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE username='$USERNAME'")
  GET_GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE username='$USERNAME'")
  echo -e "\nWelcome back, $GET_USERNAME! You have played $GET_GAMES_PLAYED games, and your best game took $GET_BEST_GAME guesses."
fi

# GAME
INITIAL_MESSAGE="\nGuess the secret number between 1 and 1000:"
TRY_NUM=0
GAME() {
  echo -e $1
  read TRY

  if [[ -z $TRY || ! $TRY =~ ^[0-9]*$ ]]
  then
    GAME "\nThat is not an integer, guess again:"
  elif [[ $RANDOM_NUM -lt $TRY ]]
  then
    TRY_NUM=$(( $TRY_NUM + 1 ))
    GAME "\nIt's lower than that, guess again:"
  elif [[ $RANDOM_NUM -gt $TRY ]]
  then
    TRY_NUM=$(( $TRY_NUM + 1 ))
    GAME "\nIt's higher than that, guess again:"
  elif [[ $RANDOM_NUM -eq $TRY ]]
  then
    TRY_NUM=$(( $TRY_NUM + 1 ))
    GAMES_PLAYED=$(( $GET_GAMES_PLAYED + 1 ))
    # check record
    if [[ $GET_BEST_GAME -gt $TRY_NUM ]]
    then
      echo "NEW RECORD: You scored $TRY_NUM, and your best score was $GET_BEST_GAME."
      # insert into new record
      UPDATE_RECORD=$($PSQL "UPDATE users SET best_game = $TRY_NUM WHERE username='$USERNAME'")
    fi
    UPDATE_NUMBER_GAMES=$($PSQL "UPDATE users SET games_played = $GAMES_PLAYED WHERE username='$USERNAME'")
    echo -e "\nYou guessed it in $TRY_NUM tries. The secret number was $TRY. Nice job!"
    exit 0
  else
    echo "ERROR!"
    exit 1
  fi
}

GAME "$INITIAL_MESSAGE"

