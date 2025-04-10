#!/bin/bash
mount -t vfat ./os.bin /mnt/d
cp ./hello.txt /mnt/d
cp ./programs/blank/build/blank.elf /mnt/d/blank.elf
umount /mnt/d
