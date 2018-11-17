# FindPortMidi.cmake
#
# Finds the PortMidi library
#
# This will define the following variables
#
#    PORTMIDI_FOUND
#
# and the following imported targets
#
#    PORTMIDI::PORTMIDI
#
# Author: Hussain AlMutawa - hussain.ali.almutawa@gmail.com

find_path(PORTMIDI_INCLUDE_DIR portmidi.h)

find_path(PORTTIME_INCLUDE_DIR porttime.h)

find_library(PORTMIDI_LIBRARY portmidi)

mark_as_advanced(PORTMIDI_FOUND PORTMIDI_INCLUDE_DIR PORTTIME_INCLUDE_DIR PORTMIDI_LIBRARY)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(PortMidi
	REQUIRED_VARS
		PORTMIDI_INCLUDE_DIR PORTTIME_INCLUDE_DIR PORTMIDI_LIBRARY
)

if(PORTMIDI_FOUND AND NOT TARGET PORTMIDI::PORTMIDI)
    add_library(PORTMIDI::PORTMIDI INTERFACE IMPORTED)
	
	set(PORTMIDI_INCLUDE_DIRS ${PORTMIDI_INCLUDE_DIR} ${PORTTIME_INCLUDE_DIR})
	list(REMOVE_DUPLICATES PORTMIDI_INCLUDE_DIRS)

	target_include_directories(PORTMIDI::PORTMIDI
		INTERFACE
			${PORTMIDI_INCLUDE_DIRS}
	)

	set(PORTMIDI_INCLUDE_DIRS)
	
	target_link_libraries(PORTMIDI::PORTMIDI
		INTERFACE
			${PORTMIDI_LIBRARY}
	)

endif()
