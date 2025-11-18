#include "fb-cpp/fb-cpp.h"


int main()
{
	[[maybe_unused]] fbcpp::BoostInt128 boostInt128;
	[[maybe_unused]] fbcpp::BoostDecFloat16 boostDecFloat16;
	[[maybe_unused]] fbcpp::BoostDecFloat34 boostDecFloat34;

	fbcpp::Client client(Firebird::fb_get_master_interface());

	return 0;
}
