CC=gcc
CXX=g++

CXXFLAGS=-Wall -Werror -g -pipe -O2 -march=prescott -fomit-frame-pointer
CFLAGS=$(CXXFLAGS) -ansi

MAKE = /usr/bin/make
RM = /bin/rm -v

DIR = src
SRC = $(wildcard *.cpp)
OBJ = $(SRC:.cpp=.o)
EXEC = <+NOM+>

.PHONY: clean all

all: $(EXEC)

$(EXEC) : $(OBJ)

%.o : %.cpp

clean :
	$(RM) $(OBJ)

mrproper: clean
	$(RM) $(EXEC)

