/*
	polly
	Copyright (C) 2016 Axel Smeets

	This program is free software; you can redistribute it and/or
	modify it under the terms of the GNU General Public License
	as published by the Free Software Foundation; either version 2
	of the License, or (at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program; if not, write to the Free Software Foundation,
	Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

*/

#include <iostream>
#include <fstream>
#include <sstream>
#include <cstring>

#include "v7.h"
#include "ip/UdpSocket.h"
#include "osc/OscReceivedElements.h"
#include "osc/OscPacketListener.h"

std::string slurp(const std::string path)
{
	std::ifstream in(path);
	return std::string(
		(std::istreambuf_iterator<char>(in)),
		std::istreambuf_iterator<char>()
	);
}

static void call_init(struct v7 *v7)
{
	auto func = v7_get(v7, v7_get_global(v7), "init", 4);
	if (v7_is_undefined(func)) {
		std::cout << "init() not found, skipping..." << std::endl;
		return;
	}

	std::string msg("message");

	auto args = v7_mk_array(v7);
	v7_array_push(v7, args, v7_mk_string(v7, msg.c_str(), msg.length(), 0));

	v7_apply(v7, func, v7_mk_undefined(), args, NULL);
}

/* */
class Server : public osc::OscPacketListener {
protected:

	virtual void ProcessMessage(const osc::ReceivedMessage& m,
				const IpEndpointName& remoteEndpoint )
	{

		try {
			if (std::strcmp(m.AddressPattern(), "/exec") == 0) {
				const char *file;
				m.ArgumentStream() >> file >> osc::EndMessage;

				/* Use v7_exec_file instead? */
				std::string js = slurp(std::string(file));
				v7* vm = v7_create();
				v7_val_t res;
				v7_exec(vm, js.c_str(), &res);
				call_init(vm);
				v7_destroy(vm);
			}
		} catch (osc::Exception& e) {
			std::cout << "ERR: " << e.what() << ": "
				<< m.AddressPattern() << std::endl;
		}
	}
};

int main()
{
	Server server;
	UdpListeningReceiveSocket s(
		IpEndpointName(IpEndpointName::ANY_ADDRESS, 8080),
		&server
	);

	std::cout << "Press Ctrl-C to exit" << std::endl;

	s.RunUntilSigInt();
}
