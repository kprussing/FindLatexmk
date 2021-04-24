get_filename_component(target ${CMAKE_ARGV3} NAME)
get_filename_component(outdir ${CMAKE_ARGV3} DIRECTORY)
execute_process(
    COMMAND ${CMAKE_COMMAND} --build . --target ${target}
    RESULT_VARIABLE success
    OUTPUT_VARIABLE stdout
    ERROR_VARIABLE stderr
)
if (NOT success EQUAL 0)
    message("STDOUT: ${stdout}")
    message("STDERR: ${stderr}")
    message(FATAL_ERROR "Error generating ${target}")
endif()
find_file(found ${target} PATHS ${outdir})
if (NOT found)
    message(FATAL_ERROR "Target ${CMAKE_ARGV3} not created!")
endif()
