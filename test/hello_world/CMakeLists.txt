add_executable(textc_test_helloworld
	helloworld.cpp)

add_text(
	TARGET textc_test_helloworld
	INPUT_DIR ${PROJECT_SOURCE_DIR}/test/hello_world
	OUTPUT_DIR ${PROJECT_BINARY_DIR}
	TEXT_FILES
		helloworld.txt
)


set_target_properties(textc_test_helloworld PROPERTIES
	CXX_STANDARD 20
	CXX_STANDARD_REQUIRED ON
	CXX_EXTENSIONS OFF)
