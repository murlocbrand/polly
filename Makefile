PROGRAM = polly

V7_FLAGS = -DV7_BUILD_PROFILE=3 -DV7_ENABLE_FILE -DV7_ENABLE_SOCKET -DV7_ENABLE_CRYPTO

# Hopefull won't change --> if so, triggers rebuild of shared object
NETSRC = $(wildcard src/ip/*.cpp) $(wildcard src/ip/posix/*.cpp)
OSCSRC = $(wildcard src/osc/*.cpp)

OBJ = bin/net.so bin/osc.so bin/polly.o bin/v7.o

# Don't use the Microsoft C++ Compiler
CPP = g++
CPPFLAGS = -I src -std=c++11

bin/$(PROGRAM): bin $(OBJ)
	$(CPP) $(CPPFLAGS) $(OBJ) -o $@

bin/v7.o: src/v7.c
	$(CC) -c $< -o $@ $(V7_FLAGS)

bin/net.so: $(NETSRC)
	$(CPP) $(CPPFLAGS) --shared -o $@ $(NETSRC)

bin/osc.so: $(OSCSRC)
	$(CPP) $(CPPFLAGS) --shared -o $@ $(OSCSRC)

bin/%.o: src/%.cpp
	$(CPP) -c $(CPPFLAGS) -o $@ $<

bin:
	mkdir bin

clean:
	rm $(OBJ) bin/$(PROGRAM)
