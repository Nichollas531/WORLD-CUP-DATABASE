#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE teams, games")

cat games_test.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WGOALS OGOALS
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
      if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
      then
        echo Insert into name, $WINNER
      fi
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
      if [[ $INSERTO == "INSERT 0 1" ]]
      then
        echo Inserted into name, $OPPONENT
      fi
    fi

    #get new opponent
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  fi

  #initiate year
  if [[ $YEAR != "year" ]]
  then

    #get year_id
    YEARID=$($PSQL "SELECT year FROM games WHERE year='$YEAR'")
    #if not found
    if [[ -z $YEARID ]]
    then
      #insert year to games
      #INSERT_YEAR=$($PSQL "INSERT INTO games(year) values($YEAR)")
      if [[ $INSERT_YEAR = "INSERT 0 1" ]]
      then
        echo "inserted into games(year), $YEAR"
      fi
    fi
    #get new year
    YEARID=$($PSQL "SELECT year FROM games WHERE year='$YEAR'")
  fi

  #initiate round
  if [[ $ROUND != "round" ]]
  then

    #get ROUND_id
    ROUNDID=$($PSQL "SELECT round FROM games WHERE round='$ROUND'")
    #if not found
    if [[ -z $ROUNDID ]]
    then
      #insert round to games
      #$INSERT_ROUND=$($PSQL "UPDATE games SET round='$ROUND' WHERE year=$YEAR;")
      INSERT_ROUND=$($PSQL "INSERT INTO games(year,round) values($YEAR,'$ROUND')")
      if [[ $INSERT_ROUND = "INSERT 0 1" ]]
      then
        echo "inserted into games(round), $ROUND"
      fi
    fi
    #get new round
    ROUNDID=$($PSQL "SELECT round FROM games WHERE round='$ROUND'")
  fi
#this is a test to work with git locally so I dont have to use github interface
done
