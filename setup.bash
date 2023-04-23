#!/bin/bash

<<com
Author: Abhinav Thakur
Email : compilepeace@gmail.com
File  : setup.bash 

PoE:
	To automate the environment setup process for ARM shellcode development. Setup currently
	installs emulation, static and dynamic analysis toolchain.

Usage:
	$ ./setup.bash
com

# Default CONFIGURATION parameters (global variables)
ARM_SHELLCODE_DEV=true
x86_SHELLCODE_DEV=true
x64_SHELLCODE_DEV=true
COLOR_BRED="\033[1m\033[31m"
COLOR_BGREEN="\033[1m\033[32m"
COLOR_BYELLOW="\033[1m\033[33m"
COLOR_RESET="\033[0m"
STATUS="failed"

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

# $1 : send "$?"
updateStatus()
{
	STATUS="failed"

	if [ "$1" -eq "0" ]; then
		STATUS="done"
	else
		STATUS="failed"
	fi
}

setupStaticAnalysisEnv()
{	
	# getting arm-linux-gnueabi-* (gcc, objdump, objcopy etc.) 
	# can verify toochain installed at /usr/arm-linux-gnueabi/
	sudo apt install -y gcc-arm-linux-gnueabi g++-arm-linux-gnueabi
	updateStatus "$?"
	debugMsg "installed ARM EABI (ARMel) toochain !" "$STATUS"
}

setupDynamicAnalysisEnv()
{
	sudo apt install -y qemu-user-static
	updateStatus "$?"
	debugMsg "downloaded usermode-emulation tool for foreign CPU architecture !" "$STATUS"

	sudo apt install -y gdb-multiarch
	updateStatus "$?"
	debugMsg "installed gdb-multiarch !" "$STATUS"

	bash -c "$(curl -fsSL https://gef.blah.cat/sh)"
	updateStatus "$?"
	debugMsg "installed GEF extension to GNU Gdb !" "$STATUS"
}

setupStaticAnalysisEnv
setupDynamicAnalysisEnv
