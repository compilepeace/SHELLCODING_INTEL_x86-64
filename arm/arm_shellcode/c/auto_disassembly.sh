#!/bin/bash

# Author: Abhinav Thakur
# Email : compilepeace@gmail.com
# Description: script will build, run and disassemble target ELF binary (supplied as argv[1] to
#              this script) every-single-time a change is made to target source file (<target>.c).
#              This is useful to understand how compilers translate high-level C/C++ code 
#              constructs into low-level assembly instructions.
# 
# Currently made for target binaries compiled for ARM CPU architecture, however, with little
# tweaks and configuration, it can be extended to work with other architectures too !
# NOTE : make sure the script is kept in the same directory as target linux binary.
# CONFIGURATION - search for this keyword to change default configuration parameters
#
# $ sudo apt install qemu-user-static		# may be required for foreign CPU architectures
#
# To monitor output/disassembly of a program, invoke this script via
# $ ./auto_disassembly.sh <target name>


# perform cleanup if user either closes terminal (SIGHUP) or presses Ctrl-c (SIGINT)
setupInterruptHandlers()
{
	trap "echo -e 'Interrupt... cleaning up x_x\n'; rm -f ./*.dis" SIGINT SIGHUP
}

# run make until building target succeeds
# $1 = target name
build()
{
	MAKE_EXIT_STATUS=1		# init make status to error
	make clean				# ensure a clean environment (for new build)
	make $1					# make target
	MAKE_EXIT_STATUS="$?"	# store make exit status

	# I've absolutely 0 fuckin clues why make failed to find $1.c, anyways keep trying until
	# build succeeds
	#while (( "$MAKE_EXIT_STATUS" != 0 ))	<-- this works only for /bin/bash not /bin/sh or dash
	while [ "$MAKE_EXIT_STATUS" -ne 0 ]
	do
		echo -e "\n[-] make failed to find: $1.c [exit status: $MAKE_EXIT_STATUS], trying again..."
		make
		MAKE_EXIT_STATUS="$?"
	done
	echo "exiting build: $MAKE_EXIT_STATUS\n"
}

# $1 = target name
run()
{
	echo -e "\n-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-\n"
	# either
	# $ export QEMU_LD_PREFIX=<path_to_installed_toolchain>
	# OR
	# $ qemu-arm -L <path_to_installed_toolchain> 
	qemu-arm-static -L /usr/arm-linux-gnueabi "$1".elf
	echo -e "\n-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-\n"
}

# $1 = target name
disassemble()
{
	"$OBJDUMP" -D "$1".elf > "$1".dis
	cat "$1".dis | less
}

# $1 = target name
main()
{
	setupInterruptHandlers
	while inotifywait "$1".c; do
		build "$1"
		run "$1"
		sleep "$SLEEP_SECONDS"
		disassemble "$1"
	done
}

#------------------------------------ MAIN LOGIC starts here -----------------------------------

# if argc < 2, print usage and exit
if [ "$#" -lt 1 ]; then
	echo -e "Usage: $0 <file_to_be_monitored>\n"
	exit 7
fi

# default CONFIGURATION parameters (change if needed)
TARGET=$(basename "$1" | sed -s 's/[.].*$//g')		# remove file extention (if provided)
OBJDUMP="arm-linux-gnueabi-objdump"
SLEEP_SECONDS=0
echo -e '[+] monitoring now => $TARGET.c\n'

# call main logic
main "$TARGET"

#-----------------------------------------------------------------------------------------------
