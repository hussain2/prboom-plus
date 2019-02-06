# FindSDL2.cmake
#
# Finds the Simple DirectMedia Layer library
#
# This will define the following variables
#
#    SDL2_FOUND
#
# and the following imported targets
#
#    SDL2::SDL2
#
# Author: Hussain AlMutawa - hussain.ali.almutawa@gmail.com

find_package(SDL2 CONFIG)

if(SDL2_FOUND AND NOT TARGET SDL2::SDL2)
    add_library(SDL2::SDL2 INTERFACE IMPORTED)

	target_include_directories(SDL2::SDL2
		INTERFACE
			${SDL2_INCLUDE_DIRS}
	)

	target_link_libraries(SDL2::SDL2
		INTERFACE
			${SDL2_LIBRARIES}
	)
endif()
