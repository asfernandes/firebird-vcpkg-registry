#include <array>
#include "firebird/ibase.h"
#include <iostream>


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
