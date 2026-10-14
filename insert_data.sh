#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
$PSQL "\dt"
$PSQL "TRUNCATE TABLE games, teams;"
cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals


do

  if [[ $winner == 'winner' ]]
  then
    continue
  fi


  # checking winners
  team=$winner
  echo "Suche Team $team in der Datenbank."
  EXISTING_TEAM=$($PSQL "SELECT team_id FROM teams WHERE name = '$team'")
  if [[ -z $EXISTING_TEAM ]]
  then
    echo "Team existiert noch nicht."
    $PSQL "INSERT INTO teams(name) VALUES('$team');"
  fi

  # checking opponents
  team=$opponent
  echo "Suche Team $team in der Datenbank."
  EXISTING_TEAM=$($PSQL "SELECT team_id FROM teams WHERE name = '$team'")
  if [[ -z $EXISTING_TEAM ]]
  then
    echo "Team existiert noch nicht."
    $PSQL "INSERT INTO teams(name) VALUES('$team');"
  fi
  
  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$winner';")
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$opponent';")

  echo "WINNER_ID is $winner_id"
  $PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($year, '$round', $WINNER_ID, $OPPONENT_ID, $winner_goals, $opponent_goals)"


done



$PSQL "SELECT * from teams;"