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
  echo "Welcome, $USERNAME! It looks like is your first time here."
  INSERT_NEW_USER=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
  GET_USERNAME=$($PSQL "SELECT username FROM users WHERE username='$USERNAME'")
  GET_BEST_GAME=0
  GET_GAMES_PLAYED=0
else
  GET_BEST_GAME=$($PSQL "SELECT best_game FROM users WHERE username='$USERNAME'")
  GET_GAMES_PLAYED=$($PSQL "SELECT games_played FROM users WHERE username='$USERNAME'")
  echo "Welcome back, $GET_USERNAME! You have played $GET_GAMES_PLAYED games, and your best game took $GET_BEST_GAME guesses."
fi

