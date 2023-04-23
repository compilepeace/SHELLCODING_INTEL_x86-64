#!/bin/bash

<<com
Author: Abhinav Thakur
Email : compilepeace@gmail.com
File  : start_debugging_session_remote.bash

PoE:
	To automate connection to a remote debugging session. Script does this by creating a gdb
	configuration file (by default in ./gdbCfg). Just start the client gdb session on localhost
	@ port 1234 and you're good to go !

Usage:
	# @ client side
	$ qemu-arm-static -g 1234 <path_to_target_elf>

	# @ your machine end
	$ ./script <path_to_target_elf> 
com


# Default CONFIGURATION parameters (global variables)
COLOR_BRED="\033[1m\033[31m"
COLOR_BGREEN="\033[1m\033[32m"
COLOR_BYELLOW="\033[1m\033[33m"
COLOR_RESET="\033[0m"
STATUS="failed"

TARGET_IP="localhost"
PORT="1234"
GDB_CONFIG_FILE="./gdbCfg"


# $1 : msg string
# $2 : one of the cases (done/fail/info)
debugMsg()
{
	MSG_STRING=""
	case "$2" in
		SUCCESS | success | DONE | done)
			MSG_STRING="$COLOR_BGREEN[+]"
			;;
		ERROR | error | FAIL | fail | FAILED | failed)
			MSG_STRING="$COLOR_BRED[-]"
			;;
		INFO | info | WARN | warn)
			MSG_STRING="$COLOR_BYELLOW[*]"
			;;
		*)								# default case
			MSG_STRING="$COLOR_RESET[ ]"
	esac
		
	MSG_STRING="$MSG_STRING $1 $COLOR_RESET"
	echo -e "$MSG_STRING"
}

# $1 : takes "$?" as parameter
updateStatus()
{
	STATUS="failed"

	if [ "$1" -eq 0 ]
	then
		STATUS="done"
	else
		STATUS="failed"
	fi
}

# $1 : stores the target binary path
startGefDebugSession()
{
	# setup GDB configuration file
	HEADER="#-x-x-x- THIS IS AN AUTO-GENERATED FILE -x-x-x-\n\n"
	CMD1="set architecture arm"
	CMD2="gef-remote --qemu-user --qemu-binary $1 $TARGET_IP $PORT" 
	echo -e "$HEADER$CMD1\n$CMD2" > "$GDB_CONFIG_FILE"
	updateStatus "$?"
	debugMsg "Created $GDB_CONFIG_FILE." "$STATUS"
	
	# start gdb-gef session (ensure that 
	debugMsg "Launching GDB session now..." "INFO"
	gdb-multiarch "$1" -x "$GDB_CONFIG_FILE"
}

# check command line arguments
if [ "$#" != 1 ]
then
	debugMsg "Usage: $0 <target_binary_path>" "failed"
	exit 1
fi

startGefDebugSession "$1"
