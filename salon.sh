#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

# Display services list
echo -e "\nWelcome to the Salon! Please choose a service:\n"
SERVICES=$($PSQL "SELECT service_id, name FROM services")
echo "$SERVICES" | while IFS="|" read SERVICE_ID SERVICE_NAME; do
  echo "$SERVICE_ID) $SERVICE_NAME"
done

# Prompt for service selection
read SERVICE_ID_SELECTED
SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
while [[ -z "$SERVICE_NAME" ]]; do
  echo -e "\nInvalid selection. Please choose again:\n"
  echo "$SERVICES" | while IFS="|" read SERVICE_ID SERVICE_NAME; do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done
  read SERVICE_ID_SELECTED
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
done

# Prompt for phone number
echo -e "\nEnter your phone number:"
read CUSTOMER_PHONE

# Check if customer exists
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

# If not, ask for name and add customer
if [[ -z "$CUSTOMER_NAME" ]]; then
  echo -e "\nEnter your name:"
  read CUSTOMER_NAME
  INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
fi

# Get customer_id
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

# Prompt for appointment time
echo -e "\nEnter appointment time:"
read SERVICE_TIME

# Insert appointment
INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

# Confirm appointment
echo -e "\nI have put you down for a $(echo $SERVICE_NAME | sed -E 's/^ *//') at $SERVICE_TIME, $CUSTOMER_NAME.\n"
