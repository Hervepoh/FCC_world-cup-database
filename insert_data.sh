#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

echo "$($PSQL "TRUNCATE TABLE games, teams;")"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    # check if WINNER name exist in the Team table
    WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")"
    if [[ -z $WINNER_ID ]] 
    then
      INSERT_TEAM_RESULT="$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER');")"
      if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $WINNER
        WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")"
      fi
    fi
    # check if exist  name exist OPPONENT in the Team table
    OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")"
    if [[ -z $OPPONENT_ID ]] 
    then
      INSERT_TEAM_RESULT="$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT');")"
      if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $OPPONENT
        OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")"
      fi
    fi
    INSERT_GAME_RESULT="$($PSQL "
    INSERT INTO 
    games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) 
    VALUES 
    ($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WINNER_GOALS,$OPPONENT_GOALS);")"
    if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
    then
        echo Inserted into games: $YEAR $ROUND $WINNER $OPPONENT $WINNER_GOALS $OPPONENT_GOALS
    fi
  fi
done
# Do not change code above this line. Use the PSQL variable above to query your database.
