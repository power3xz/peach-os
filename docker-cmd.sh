#!/bin/bash
mount -t vfat ./os.bin /mnt/d
cp ./hello.txt /mnt/d
cp ./programs/blank/build/blank.bin /mnt/d/blank.bin
umount /mnt/d
