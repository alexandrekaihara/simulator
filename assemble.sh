#!/bin/bash

nasm -f elf implementation.asm
nasm -f elf file_handler.asm
nasm -f elf instructions.asm
nasm -f elf print.asm
nasm -f elf convert.asm
gcc simulator.c implementation.o file_handler.o instructions.o print.o convert.o -o simulator