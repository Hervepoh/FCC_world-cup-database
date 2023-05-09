#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo "$($PSQL "TRUNCATE TABLE games, teams;")"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != "winner" ]] 
  then
    # check if exist 
    TEAM_ID="$($PSQL "SELECT * FROM teams WHERE name='$WINNER';")"
    if [[ -z $TEAM_ID ]] 
    then
      INSERT_TEAM_RESULT="$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER');")"
      if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $WINNER
      fi
    fi
    # check if exist 
    TEAM_ID="$($PSQL "SELECT * FROM teams WHERE name='$OPPONENT';")"
    if [[ -z $TEAM_ID ]] 
    then
      INSERT_TEAM_RESULT="$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT');")"
      if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $OPPONENT
      fi
    fi
  fi
done
