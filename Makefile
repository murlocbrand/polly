PROGRAM = plugga

NET_PATH = src/ip
NET_PATH_OS = $(NET_PATH)/posix

NETSRC = $(NET_PATH)/IpEndpointName.cpp $(NET_PATH_OS)/NetworkingUtils.cpp $(NET_PATH_OS)/UdpSocket.cpp

OSC_PATH = src/osc
OSCSRC = $(OSC_PATH)/OscOutboundPacketStream.cpp $(OSC_PATH)/OscPrintReceivedElements.cpp $(OSC_PATH)/OscReceivedElements.cpp $(OSC_PATH)/OscTypes.cpp

SRC = $(NETSRC) $(OSCSRC) src/plugga.cpp

# Use the Microsoft C++ Compiler
CPP = g++
CPPFLAGS = -I src -o $@


bin/$(PROGRAM): bin $(SRC)
	$(CPP) $(CPPFLAGS) $(SRC)

bin:
	mkdir bin

# clean
clean:
	rm $(OBJ) bin/$(PROGRAM)
