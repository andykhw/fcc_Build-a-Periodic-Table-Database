#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
#A program to print the information of elements in the periodic table database 

#check if the input is a number
if [[ $1 =~ ^[0-9]+$ ]]
then
  #do query of searching by integer
  SEARCH_BY_ATOMIC_NUMBER=$($PSQL "SELECT * FROM elements WHERE atomic_number=$1")
else
  #do queries of searching with strings for both symbol and name
  SEARCH_BY_SYMBOL=$($PSQL "SELECT * FROM elements WHERE symbol='$1'")
  SEARCH_BY_NAME=$($PSQL "SELECT * FROM elements WHERe name='$1'")
fi

#Function to print the information of element when Input is valid
PRINT_INFORMATION(){
  PROPERTIES_GET=$($PSQL "SELECT atomic_mass,melting_point_celsius,boiling_point_celsius,type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
  IFS="|" read ATOMIC_MASS MEL_POINT BOIL_POINT TYPE_ID <<< $PROPERTIES_GET
  TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")

  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MEL_POINT celsius and a boiling point of $BOIL_POINT celsius."
}

#If there is input
if [[ $1 ]]
then
  #If it is a atomic number of an element in the elements table, look for more properties 
  if [[ -n $SEARCH_BY_ATOMIC_NUMBER ]]
  then
    IFS="|" read ATOMIC_NUMBER SYMBOL NAME <<< $SEARCH_BY_ATOMIC_NUMBER 
    PRINT_INFORMATION
    
  #If it is a symbol of an element in the elements table, look for more properties
  elif [[ -n $SEARCH_BY_SYMBOL ]]
  then
    IFS="|" read ATOMIC_NUMBER SYMBOL NAME <<< $SEARCH_BY_SYMBOL
    PRINT_INFORMATION

  #If it is a name of an element in the elements table, look for more properties
  elif [[ -n $SEARCH_BY_NAME ]]
  then
    IFS="|" read ATOMIC_NUMBER SYMBOL NAME <<< $SEARCH_BY_NAME 
    PRINT_INFORMATION
  else
    echo "I could not find that element in the database."
  fi
#No input message
else
  echo "Please provide an element as an argument."
fi
