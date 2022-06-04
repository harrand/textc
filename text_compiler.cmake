include (CMakeParseArguments)

function(add_text)
	set(TEXTC_EXECUTABLE_PATH $<TARGET_FILE:textc>)
	cmake_parse_arguments(
		ADD_TEXT
		""
		"TARGET;INPUT_DIR;OUTPUT_DIR"
		"TEXT_FILES"
		${ARGN}
	)

	get_target_property(tar_cxx_ver ${ADD_TEXT_TARGET} CXX_STANDARD)
	if(NOT tar_cxx_ver GREATER_EQUAL 20)
		if(${tar_cxx_ver} MATCHES tar_cxx_ver-NOTFOUND)
			message(WARNING "Target \"${ADD_TEXT_TARGET}\" does not explicitly define a C++ standard version. Default compiler C++ standard version is assumed to be 20, but if not your target will shortly fail to build.")
		else()
			message(SEND_ERROR "Target \"${ADD_TEXT_TARGET}\" is not specified to use C++20. It is using C++${tar_cxx_ver}")
		endif()
	endif()

	foreach(TEXT ${ADD_TEXT_TEXT_FILES})
		set(text_path ${ADD_TEXT_INPUT_DIR}/${TEXT})
		set(output_name ${TEXT}.hpp)
		set(output_path ${ADD_TEXT_OUTPUT_DIR}/${output_name})
		cmake_path(GET output_path PARENT_PATH text_dirname)
		add_custom_command(
			OUTPUT ${output_path}
			COMMENT "TEXTC: Bundling ${TEXT} -> ${output_name}"
			COMMAND "${TEXTC_EXECUTABLE_PATH}" ${text_path} -o ${output_path}
			DEPENDS textc ${text_path}
			IMPLICIT_DEPENDS CXX
			VERBATIM
		)

		set_source_files_properties(${output_path} PROPERTIES GENERATED TRUE)
		target_sources(${ADD_TEXT_TARGET} PRIVATE ${output_path})
		# FInally, create a target represening the header so we can depend on it.
		get_filename_component(text_name ${output_path} NAME_WLE)
		set(text_header_library ${ADD_TEXT_TARGET}_${text_name})
		add_library(${text_header_library} INTERFACE)
		target_include_directories(${text_header_library} INTERFACE ${text_dirname})
		target_link_libraries(${ADD_TEXT_TARGET} PRIVATE textc_lib ${text_header_library})
	endforeach()
endfunction()
