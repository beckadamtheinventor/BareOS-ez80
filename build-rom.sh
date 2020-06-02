#!/bin/bash

mkdir open-ce/bin
fasmg open-ce/src/main.asm open-ce/bin/OPENCE.rom
mkdir bin
echo 'file "open-ce/bin/OPENCE.rom"
file "bin/BareOS.bin"'  >> bin/temp.asm
fasmg bin/temp.asm bin/BareOS.rom
rm bin/temp.asm

read -p "Finished. Press enter to complete."
