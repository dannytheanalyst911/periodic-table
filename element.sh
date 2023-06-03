#!/usr/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ -z $1 ]]
then 
  echo  "Please provide an element as an argument."
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    INFO=$($PSQL "select * from elements inner join properties using(atomic_number) inner join types using(type_id) where elements.atomic_number = $1")
  else
    INFO=$($PSQL "select * from elements inner join properties using(atomic_number) inner join types using(type_id) where elements.symbol = '$1' or elements.name = '$1'")
  fi

  if [[ -z $INFO ]]
  then
    echo "I could not find that element in the database."
  else
    echo $INFO | while IFS="|" read X ATOMIC SYMBOL NAME MASS MELT BOIL TYPE
    do
      echo  "The element with atomic number $ATOMIC is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
    done
  fi
fi
