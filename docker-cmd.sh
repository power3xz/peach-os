#!/bin/bash
mount -t vfat ./os.bin /mnt/d
cp ./hello.txt /mnt/d
cp ./programs/blank/build/blank.elf /mnt/d/blank.elf
cp ./programs/shell/build/shell.elf /mnt/d/shell.elf
umount /mnt/d
