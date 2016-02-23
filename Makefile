PROGRAM = plugga

NET_PATH = src/ip
NET_PATH_OS = $(NET_PATH)/posix

NETSRC = $(NET_PATH)/IpEndpointName.cpp $(NET_PATH_OS)/NetworkingUtils.cpp $(NET_PATH_OS)/UdpSocket.cpp
NETOBJ = bin/IpEndpointName.o bin/NetworkingUtils.o bin/UdpSocket.o

OSC_PATH = src/osc
OSCSRC = $(OSC_PATH)/OscOutboundPacketStream.cpp $(OSC_PATH)/OscPrintReceivedElements.cpp $(OSC_PATH)/OscReceivedElements.cpp $(OSC_PATH)/OscTypes.cpp
OSCOBJ = bin/OscOutboundPacketStream.o bin/OscPrintReceivedElements.o bin/OscReceivedElements.o bin/OscTypes.o

SRC = $(NETSRC) $(OSCSRC) src/plugga.cpp

# names of object files
OBJ = $(NETOBJ) $(OSCOBJ) bin/plugga.o

# Use the Microsoft C++ Compiler
CPP = g++
CPPFLAGS = -c -I src -o $@

LINK = ld
LINKFLAGS = -o $@

bin/$(PROGRAM): bin $(OBJ)
	$(LINK) $(LINKFLAGS) $(OBJ)

bin/%.o: $(SRC)
	$(CPP) $(CPPFLAGS) $<

bin:
	mkdir bin

# clean
clean:
	rm $(OBJ) bin/$(PROGRAM)
