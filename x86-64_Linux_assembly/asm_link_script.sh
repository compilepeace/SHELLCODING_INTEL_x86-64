#!/bin/bash

if [ $# -lt 1 ]
then
	echo -e "[-] Usage ./script <filename.asm>\n"
	exit
fi

yasm -f elf64 -g dwarf2 -l $1.lst $1.asm
ld $1.o -o $1
