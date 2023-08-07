cmake_minimum_required(VERSION 3.9)
project(textc VERSION 1.0
	DESCRIPTION "Tool to convert any file into a specialised C++ header")
include(text_compiler.cmake)

add_executable(textc
	textc/textc_main.cpp
)
target_compile_definitions(textc PRIVATE -D_CRT_SECURE_NO_WARNINGS)

set_target_properties(textc PROPERTIES
	CXX_STANDARD 20
	CXX_STANDARD_REQUIRED ON
	CXX_EXTENSIONS OFF)


add_library(textc_lib INTERFACE)
target_include_directories(textc_lib INTERFACE .)

set_target_properties(textc_lib PROPERTIES
	CXX_STANDARD 20
	CXX_STANDARD_REQUIRED ON
	CXX_EXTENSIONS OFF)
target_compile_definitions(textc_lib INTERFACE -D_CRT_SECURE_NO_WARNINGS)

add_subdirectory(test)
