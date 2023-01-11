#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

MAIN_MENU() {
  echo -e "\n~~~ Number Guessing Game ~~~\n"

  # username
  echo "Enter your username:"
  read USERNAME

  # try to get username from db
  GET_USER_ID=$($PSQL "SELECT user_id FROM users WHERE name='$USERNAME'")

  # if username is not in db
  if [[ -z $GET_USER_ID ]]
  then
    echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."

    # insert new user -> database
    INSERT_NEW_USER=$($PSQL "INSERT INTO users(name) VALUES('$USERNAME')")

    # get the user_id
    GET_USER_ID=$($PSQL "SELECT user_id FROM users WHERE name='$USERNAME'")

  # if username exists
  else
    GAMES_PLAYED=$($PSQL "SELECT COUNT(user_id) FROM games WHERE user_id='$GET_USER_ID'")
    BEST_GAME=$($PSQL "SELECT MIN(guesses) FROM games WHERE user_id='$GET_USER_ID'")
    echo -e "\nWelcome back, $USERNAME! You have player $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  fi

  # execute game
  GAME
}

GAME() {
  # 1 to 1000, both inclusive, random number
  NUMBER_TO_GUESS=$(( 1 + $RANDOM%1000 ))

  # initialize number of tries
  NUM_TRIES=0

  echo -e "\nGuess the secret number between 1 to 1000:"

  # loop until player finds the final guess
  while [[ $NUMBER_TO_GUESS -ne $GUESS ]]
  do
    read GUESS

    # check $GUESS is valid number
    if [[ ! $GUESS =~ ^[0-9]+$ ]]
    then
      echo -e "\nThat is not an integer, guess again:"

    # case you guess a number lower
    elif [[ $GUESS -lt $NUMBER_TO_GUESS ]]
    then
      NUM_TRIES=$(( $NUM_TRIES + 1 ))
      echo -e "\nIt's higher than that, guess again:"

    # case you guess a number higher
    elif [[ $GUESS -gt $NUMBER_TO_GUESS ]]
    then
      NUM_TRIES=$(( $NUM_TRIES + 1 ))
      echo -e "\nIt's lower than that, guess again:"

    # case you guess the right number
    else
      NUM_TRIES=$(( $NUM_TRIES + 1 ))
      echo -e "You guessed it in $NUM_TRIES tries. The secret number was $NUMBER_TO_GUESS. Nice job!"

      # insert score to games table
      INSERT_SCORE=$($PSQL "INSERT INTO games(user_id, guesses) VALUES($USER_ID, $NUM_TRIES)")
    
    fi
  done

}

MAIN_MENU
