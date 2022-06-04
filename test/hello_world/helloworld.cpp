#include <cassert>
#include <cstdio>

#include "textc/imported_text.hpp"
#include ImportedTextHeader(helloworld, txt)

#undef NDEBUG

int main()
{
	std::string_view helloworld = ImportedTextData(helloworld, txt);
	if(helloworld == "hello world!")
	{
		return 0;
	}
	else
	{
		std::fprintf(stderr, "Helloworld text file contained invalid data. Expected \"hello world!\", but got \"%s\"\n", helloworld.data());
		return -1;
	}
}
