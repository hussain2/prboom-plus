
message("CMAKE_PREFIX_PATH: ${CMAKE_PREFIX_PATH}")

#find_package(${PROJECT_NAME} REQUIRED)
find_package(SDL2 REQUIRED)
find_package(dumb)
find_package(PortMidi REQUIRED)
find_package(Mad REQUIRED)
find_package(FluidSynth REQUIRED)

 add_library(libdoommusic STATIC
	dbopl dumbplayer flplayer madplayer midifile opl oplplayer opl_queue portmidiplayer vorbisplayer
)

target_link_libraries(libdoommusic PUBLIC ${PROJECT_NAME} SDL2::SDL2 PortMidi::PortMidi)
