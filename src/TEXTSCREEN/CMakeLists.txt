find_package(SDL2)

 add_library(libtextscreen STATIC
	txt_sdl
)

target_include_directories(libtextscreen PUBLIC ${PROJECT_NAME} SDL2::SDL2)
target_link_libraries(libtextscreen PUBLIC ${PROJECT_NAME} SDL2::SDL2)
