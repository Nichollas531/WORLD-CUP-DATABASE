#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE teams, games")
COUNTER=1
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WGOALS OGOALS
do
  #initiate winner
  if [[ $WINNER != "winner" ]]
  then
    #get winner_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name ='$WINNER' ")

    #if not found
    if [[ -z $WINNER_ID ]]
    then
      
      #insert winner
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      
    fi
    #get new winner
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  fi

  #initiate opponent
  if [[ $OPPONENT != "opponent" ]]
  then
    #get opponent_id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    #if not found
    if [[ -z $OPPONENT_ID ]]
    then

      #inser opponent to name
      INSERTO=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      
    fi

    #get new opponent
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  fi

if [[ $ROUND != 'round' ]]
then
      INSERT_ROUND=$($PSQL "INSERT INTO games(year,round,winner_goals, opponent_goals,winner_id, opponent_id) values($YEAR,'$ROUND',$WGOALS,$OGOALS,$WINNER_ID,$OPPONENT_ID)")
      if [[ $INSERTO == "INSERT 0 1" ]]
      then
        echo "Inserted line $COUNTER to games table"
        COUNTER=$[COUNTER + 1]
      fi
fi
done