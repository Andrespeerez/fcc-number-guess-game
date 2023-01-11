#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=<database_name> -t --no-align -c"

echo -e "\n~~~ Number Guessing Game ~~~\n"

# username
echo "Enter your username:"
read USERNAME

# try to get username from db
GET_USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
