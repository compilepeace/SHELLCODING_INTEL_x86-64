#!/bin/bash

echo -e "building target: $1\n"
arm-linux-gnueabi-gcc -g -Wl,-N -nostdlib -static "$1"
echo -e "build status: $?"
