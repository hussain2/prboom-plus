
 add_library(libposixdoom STATIC i_system)

target_include_directories(libposixdoom PUBLIC ${PROJECT_NAME})
target_link_libraries(libposixdoom PUBLIC ${PROJECT_NAME})
