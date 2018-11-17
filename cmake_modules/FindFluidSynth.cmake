# FindDUMB.cmake
#
# Finds the fluidsynth library
#
# This will define the following variables
#
#    FLUIDSYNTH_FOUND
#
# and the following imported targets
#
#    FLUIDSYNTH::FLUIDSYNTH
#
# Author: Hussain AlMutawa - hussain.ali.almutawa@gmail.com

find_path(FLUIDSYNTH_INCLUDE_DIR fluidsynth.h)

find_library(FLUIDSYNTH_LIBRARY fluidsynth)

mark_as_advanced(FLUIDSYNTH_FOUND FLUIDSYNTH_INCLUDE_DIR FLUIDSYNTH_LIBRARY)

INCLUDE(FindPackageHandleStandardArgs)
find_package_handle_standard_args(FluidSynth
	REQUIRED_VARS
		FLUIDSYNTH_INCLUDE_DIR FLUIDSYNTH_LIBRARY
)

if(FLUIDSYNTH_FOUND AND NOT TARGET FLUIDSYNTH::FLUIDSYNTH)
    add_library(FLUIDSYNTH::FLUIDSYNTH INTERFACE IMPORTED)
	
	target_include_directories(FLUIDSYNTH::FLUIDSYNTH
		INTERFACE
			${FLUIDSYNTH_INCLUDE_DIR}
	)

	target_link_libraries(FLUIDSYNTH::FLUIDSYNTH
		INTERFACE
			${FLUIDSYNTH_LIBRARY}
	)

endif()
