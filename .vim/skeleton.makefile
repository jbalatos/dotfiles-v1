CC=g++

CFLAGS=-g -Wall -O2 -std=c++11

TARGET=target

all: $(TARGET)

$(TARGET): $(TARGET).cpp
	$(CC) $(CFLAGS) -o $(TARGET) $(TARGET).cpp
