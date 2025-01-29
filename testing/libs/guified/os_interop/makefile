# Compiler
CC = gcc

# Compilation flags
CFLAGS = -Wall -fPIC -llua5.1

# Source and output files
SRC = linux.c
OBJ = $(SRC:.c=.o)
SO = linux.so

# Rule to build the shared object
$(SO): $(OBJ)
	$(CC) -shared -o $(SO) $(OBJ)

# Rule to build object files
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Clean up the build files
clean:
	rm -f $(OBJ) $(SO)

run:
	love ./../../../