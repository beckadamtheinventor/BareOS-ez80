#!/bin/bash

echo 'file "'$1'"
file "bin/BareOS.bin"'  >> bin/temp.asm
fasmg bin/temp.asm bin/BareOS.rom
rm bin/temp.asm

