
find_package(SDL2 REQUIRED)

 add_library(libpcsound STATIC
	pcsound pcsound_sdl
	pcsound_win32
)

target_include_directories(libpcsound PUBLIC ${PROJECT_NAME} SDL2::SDL2)
target_link_libraries(libpcsound PUBLIC ${PROJECT_NAME} SDL2::SDL2)
