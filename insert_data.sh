#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams CASCADE")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $OPPONENT != "opponent" ]]
  then
    #get team_id to check if name already exists
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name ='$OPPONENT'")
    WINNER_ID=$($PSQL "SELECT team_id FROM teams where name='$WINNER'")

    #echo $OPPONENT
    #echo $NAME
    
    if [[ -z $OPPONENT_ID ]]
    then
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")

      if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into team, $OPPONENT
      fi
    fi

    if [[ -z $WINNER_ID  ]]
    then
      INSERT_TEAM_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")

      if [[ $INSERT_TEAM_WINNER_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into team, $WINNER
      fi
    fi
  fi
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do  
  if [[ $WINNER != "winner" && $OPPONENT != "opponent" ]]
  then
    WINNER_ID=$($PSQL "SELECT team_id FROM teams where name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name ='$OPPONENT'")
    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    echo Inserted into Game: Winner $WINNER, Opponent $OPPONENT
  fi
done
