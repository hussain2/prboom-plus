
find_package(SDL2)
find_package(SDL2_IMAGE)

 add_library(libsdldoom STATIC
	i_main i_network i_video i_sound i_system i_joy i_sshot
	SDL_windows_main
)

target_include_directories(libsdldoom PUBLIC ${PROJECT_NAME} libtextscreen SDL2::SDL2 SDL2_IMAGE::SDL2_IMAGE)
target_link_libraries(libsdldoom PUBLIC ${PROJECT_NAME} libtextscreen SDL2::SDL2 SDL2_IMAGE::SDL2_IMAGE)
