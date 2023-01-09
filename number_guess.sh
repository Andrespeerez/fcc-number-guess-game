#!/bin/bash
# Guessing number game
PSQL="psql --username=freecodecamp --dbname=<database_name> -t --no-align -c"
RANDOM_NUM=$((1+$RANDOM%1000))

echo "Enter your username:"
read USERNAME

GET_USERNAME=$($PSQL "SELECT username FROM users WHERE username=$USERNAME")
# check if is null
if [[ -z $USERNAME ]]
then
  echo "Introduce a name."
  exit 1
elif [[ -z $GET_USERNAME ]]
then
  echo "Welcome, $USERNAME! It looks like is your first time here."
  INSERT_NEW_USER=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
  GET_USERNAME=$($PSQL "SELECT username FROM users WHERE username=$USERNAME")
else
  echo "Welcome back, $GET_USERNAME! You have played games, and your best game took guesses."
fi