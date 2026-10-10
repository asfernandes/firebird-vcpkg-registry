#include <array>
#include "firebird/Interface.h"
#include "firebird/Message.h"
#include "firebird/ibase.h"
#include <iostream>


FB_MESSAGE(TestMessage, ::Firebird::ThrowStatusWrapper,
	(FB_INTEGER, id)
	(FB_VARCHAR(30), name)
);


int main()
{
	std::array<char, 64> version{};
	isc_get_client_version(version.data());

	const int major = isc_get_client_major_version();
	const int minor = isc_get_client_minor_version();

	std::cout <<
		"Linked against Firebird client " <<
		version.data() <<
		" (major " << major << ", minor " << minor << ")\n";

	return 0;
}
