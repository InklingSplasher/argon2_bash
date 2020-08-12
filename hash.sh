#!/bin/bash
# Just a little script to verify argon2 hashes
# Script by inklingsplasher; https://keybase.io/inklingsplasher; https://github.com/InklingSplasher

# Colors for making stuff cooler
RED='\033[0;31m'
LIGHT_RED='\033[1;31m'
LIGHT_GREEN='\033[1;32m'
LIGHT_BLUE='\033[1;34m'
NC='\033[0m' # No Color

# Set ARGONDIR to the directory where the argon2 executable is located.
# Set SALTDIR to the directory where the salt for argon2 is located.

ARGONDIR="/root/Misc/argon2/argon2"
SALTDIR="./salt.txt"
SALT=$( cat $SALTDIR )

echo -e "${LIGHT_GREEN}Enter the operation: ${LIGHT_RED}hash${LIGHT_GREEN}/${LIGHT_BLUE}verify:${NC}"
read -r op

if [[ $op = hash ]]
then
	echo -e "${LIGHT_GREEN}Enter the password:${NC}"
	read -r "password"
	echo -n "${password}" | $ARGONDIR "${SALT}" -r

	echo -e "${LIGHT_GREEN}Run the script again? (y/n):${NC}"
	read -r "run_again"
	if [[ $run_again = "y" ]]
	then
		exec bash "$0" "$@"
	else
		exit 1
	fi

elif [[ $op = verify ]]
then
	echo -e "${LIGHT_GREEN}Enter the password:${NC}"
	read -r "password"
	echo -e "${LIGHT_GREEN}Corresponding hash:${NC}"
	read -r "verifyhash"
	HASH=$( echo -n "${password}" | $ARGONDIR "${SALT}" -r )
	if [[ $HASH = "$verifyhash" ]]
	then
		echo -e "${LIGHT_GREEN}Verification ok!${NC}"
	else
		echo -e "${LIGHT_RED}Verification not ok!${NC}"
	fi

	echo -e "${LIGHT_GREEN}Run the script again? (y/n):${NC}"
	read -r "run_again"
	if [[ $run_again = "y" ]]
	then
		exec bash "$0" "$@"
	else
                exit 1
        fi

else
	echo -e "${RED}ERROR: Operation unknown.${NC}"
fi
