FILES=./build/shell.o
INCLUDES= -I../stdlib/src
FLAGS= -g -ffreestanding -falign-jumps -falign-functions -falign-labels -falign-loops -fstrength-reduce -fomit-frame-pointer -finline-functions -Wno-unused-function -fno-builtin -Werror -Wno-unused-label -Wno-cpp -Wno-unused-parameter -nostdlib -nostartfiles -nodefaultlibs -Wall -O0 -Iinc

all: ${FILES}
	i686-elf-gcc -g -T ./linker.ld -o ./build/shell.elf -ffreestanding -O0 -nostdlib -fpic -g ${FILES} ../stdlib/build/stdlib.elf

./build/shell.o: ./shell.c
	i686-elf-gcc ${INCLUDES} -I./ $(FLAGS) -std=gnu99 -c ./shell.c -o ./build/shell.o

clean:
	rm -rf ./build
	mkdir ./build
