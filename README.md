# textc

Textc is a tool which allows you to convert a file to a C++ header.

## Code Generation
Given the following file:

------
text.txt
```text
hello world.

this is some text.
```

The following header is generated:

------
text.txt.hpp
```cpp
#include <cstdint>
#include <array>
/*textc_gen_header*/constexpr std::array<std::int8_t, 34> text_txt{104,101,108,108,111,32,119,111,114,108,100,46,13,10,13,10,116,104,105,115,32,105,115,32,115,111,109,101,32,116,101,120,116,46};
```

## Usage

There are two main ways to use textc.

### Command-line Tool
The most intuitive way to use textc is to simply invoke it as a normal program. Its argument usage is as follows:

`textc <file-path> [-o <output_file_path>]`

If no output path (`-o`) is specified, the output is available through stdout instead.

### CMake Utility
Textc has first-class support for CMake projects. By including textc as a subdirectory in your cmake project, you gain access to a new function:

```cmake
add_text(TARGET <target> 
	INPUT_DIR <input_dir>
	OUTPUT_DIR <output_dir>
	TEXT_FILES <TEXT_FILE_PATHS>
)
```

Associates zero or more text-files within the list `TEXT_FILE_PATHS` with the existing target `target`. The target should be an executable or a library. The following pseudocode explains the functionality of this:

```cs
// At build time
for text_file_path in TEXT_FILE_PATHS:
	full_input_path = INPUT_DIR + text_file_path
	full_output_path = OUTPUT_DIR + text_file_path
	header_data = convert_to_header(file_read(full_input_path))
	file_write(full_output_path, header_data)
```

In addition, doing this through CMake allows you to very easily access the header at compile-time.

- `textc` is a target which generates the executable used above.
- `textc_lib` is a very small library which can be linked against to access compiled headers extremely easily.
	- Contains two functions in `textc/imported_text.hpp`:
		1. ImportedTextHeader(filename, extension)
			- Macro which resolves to an expression, namely a path to the header.
			- This allows you to do the following:
				- `#include ImportedTextHeader(my_file, txt)`
		2. ImportedTextData(filename, extension)
			- Macro which resolves to a `std::string_view` containing the file's data. Due to slow compiler support, this is not yet constexpr.
			- `ImportedTextHeader(filename, extension)` must have been invoked earlier within the translation unit.