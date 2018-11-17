# FindMad.cmake
#
# Finds the MPEG Audio Decoder library
#
# This will define the following variables
#
#    MAD_FOUND
#
# and the following imported targets
#
#    MAD::MAD
#
# Author: Hussain AlMutawa - hussain.ali.almutawa@gmail.com

find_path(MAD_INCLUDE_DIR mad.h)

find_library(MAD_LIBRARY mad)

mark_as_advanced(MAD_FOUND MAD_INCLUDE_DIR MAD_LIBRARY)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(MAD
	REQUIRED_VARS
		MAD_INCLUDE_DIR MAD_LIBRARY
)

if(MAD_FOUND AND NOT TARGET MAD::MAD)
    add_library(MAD::MAD INTERFACE IMPORTED)

	target_include_directories(MAD::MAD
		INTERFACE
			${MAD_INCLUDE_DIR}
	)

	target_link_libraries(MAD::MAD
		INTERFACE
			${MAD_LIBRARY}
	)
endif()
