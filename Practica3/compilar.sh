#!/usr/bin/bash
set -e 

echo -e Ingresa el nombre del archivo
read file

echo --------------- ASSEMBLING ----------------
echo Assembling file: $file.s - $(date +%H:%M:%S)
aarch64-linux-gnu-as -o $file.o $file.s

if [ $? -eq 0 ]; then
    echo Assembling successful
else
    echo Assembling failed
    exit 1
fi

echo ==========================================

echo ---------------- LINKING -----------------
echo Linking file: $file.o - $(date +%H:%M:%S)
aarch64-linux-gnu-ld -o $file $file.o

if [ $? -eq 0 ]; then
    echo Object file created
else
    echo Object file not created
    exit 1
fi

echo ==========================================

echo Done compiling and linking file: $file - $(date +%H:%M:%S)
echo Debugging the file $file
qemu-aarch64 ./$file
#rm $file.o $file