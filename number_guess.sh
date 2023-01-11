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
    INSERT_NEW_USER=$($PSQL "INSERT INTO users(name) VALUE('$USERNAME')")

    # get the user_id
    GET_USER_ID=$($PSQL "SELECT user_id FROM users WHERE name='$USERNAME'")

  # if username exists
  else
    GAMES_PLAYED=$($PSQL "SELECT COUNT(user_id) FROM games WHERE user_id='$GET_USER_ID'")
    BEST_GAME=$($PSQL "SELECT MIN(guesses) FROM games WHERE user_id='$GET_USER_ID'")
    echo -e "\nWelcome back, $USERNAME! You have player $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  fi

}


MAIN_MENU