#format is target-name: target dependencies
#{-tab-}actions

# All Targets
all: ass3

# Tool invocations
# Executable "hello" depends on the files hello.o and run.o.
ass3: ass3.o coroutines.o printer.o scheduler.o cell.o
	gcc -m32 -g -Wall -o ass3 coroutines.o ass3.o printer.o scheduler.o cell.o

# Depends on the source and header files
ass3.o: ass3.s 
	nasm -g -f elf -w+all -o ass3.o ass3.s
cell.o: cell.c
	gcc -m32 -g -ansi -Wall -c -o cell.o cell.c
coroutines.o: coroutines.s
	nasm -g -f elf -w+all -o coroutines.o coroutines.s
printer.o: printer.s
	nasm -g -f elf -w+all -o printer.o printer.s
scheduler.o: scheduler.s
	nasm -g -f elf -w+all -o scheduler.o scheduler.s


#tell make that "clean" is not a file name!
.PHONY: clean

#Clean the build directory
clean: 
	rm -f *.o ass3