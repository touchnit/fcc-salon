#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

MAIN_MENU() {
echo -e $1
echo "$($PSQL "SELECT * FROM services;")" | while read -r ID BAR NAME
  do 
    echo "$ID) $NAME"
  done
echo -e "\n"

read SERVICE_ID_SELECTED
SERVICE=$($PSQL "SELECT * FROM services WHERE service_id = '$SERVICE_ID_SELECTED';")
SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED;" | sed 's/ //g')
if [[ ! -z $SERVICE ]]
then
  echo -e "\nWhat's your phone number?\n"
  read CUSTOMER_PHONE
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';")
  if [[ -z $CUSTOMER_ID ]]
    then
      echo -e "\nI don't have a record for that phone number, what's your name?\n"
      read CUSTOMER_NAME
      NEW_CUSTOMER=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE');")
    else
      CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id = '$CUSTOMER_ID';" | sed 's/ //g')
  fi
  echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME ?\n"
  read SERVICE_TIME
else
  MAIN_MENU "We do not propose that, please choose a service we propose \n"
fi
ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';")
NEW_APPOINTMENT="$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")"
echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}

MAIN_MENU "\n~~ Welcome to the hair salon, choose a service ~~ \n";
