#!/bin/bash
mount -t vfat ./os.bin /mnt/d
cp ./hello.txt /mnt/d
umount /mnt/d
