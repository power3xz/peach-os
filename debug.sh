# run qemu in background and wait for gdb to connect
qemu-system-x86_64 -hda ./bin/boot.bin -s -S & lldb -o "gdb-remote localhost:1234" -o "break *0x7c00" -o "continue"
