#!/bin/bash

# CONFIGURATION PARAMETERS
ARM_SHELLCODE_DEV=true
AMD_SHELLCODE_DEV=true
COLOR_BRED="\033[1m\033[31m"
COLOR_BGREEN="\033[1m\033[32m"
COLOR_BYELLOW="\033[1m\033[33m"
COLOR_RESET="\033[0m"

debugMsg()
{
	MSG_STRING=""
	case "$2" in
		SUCCESS | success | done)
			MSG_STRING="$COLOR_BGREEN[+]"
			;;
		ERROR | error | fail)
			MSG_STRING="$COLOR_BRED[-]"
			;;
		INFO | info | warn)
			MSG_STRING="$COLOR_BYELLOW[*]"
			;;
		*)								# default case
			MSG_STRING="$COLOR_RESET[ ]"
	esac
		
	MSG_STRING="$MSG_STRING $1 $COLOR_RESET"
	echo -e "$MSG_STRING"
}

setupStaticAnalysisEnv()
{	
	# getting arm-linux-gnueabi-* (gcc, objdump, objcopy etc.) 
	# can verify toochain installed at /usr/arm-linux-gnueabi/
	debugMsg "installing ARM EABI (ARMel) toochain..." done
	sudo apt install -y gcc-arm-linux-gnueabi g++-arm-linux-gnueabi
}

setupDynamicAnalysisEnv()
{
	debugMsg "getting usermode-emulation tool for foreign CPU architecture..." done
	sudo apt install -y qemu-user-static

	debugMsg "getting gdb-multiarch..." done
	sudo apt install -y gdb-multiarch

	debugMsg "installing GEF extension to GNU Gdb..." done
	bash -c "$(curl -fsSL https://gef.blah.cat/sh)"
}

setupStaticAnalysisEnv
setupDynamicAnalysisEnv
