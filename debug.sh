#!/bin/bash

# QEMU 시작 및 PID 저장
qemu-system-i386 -s -S -hda ./bin/os.bin &
QEMU_PID=$!

# GDB 연결
x86_64-elf-gdb -x ./gdb-commands.txt

# GDB 종료 후 QEMU도 종료
kill $QEMU_PID
