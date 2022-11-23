#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# Remove data
echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR  ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' ]]
  then
    # get team id, if not present insert it 
    WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name ='$WINNER'")
    if [[ -z $WIN_ID ]]
    then
      $($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    fi
    WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    if [[ -z $OPP_ID ]]
    then
      $($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    fi
    OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name ='$OPPONENT'")

    # Inserting game values
    $($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WIN_ID, $OPP_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    
  fi
  
done