# FindDUMB.cmake
#
# Finds the Dynamic Universal Music Bibliotheque library
#
# This will define the following variables
#
#    DUMB_FOUND
#
# and the following imported targets
#
#    DUMB::DUMB
#
# Author: Hussain AlMutawa - hussain.ali.almutawa@gmail.com

find_path(DUMB_INCLUDE_DIR dumb.h)

find_library(DUMB_LIBRARY dumb libdumb)

mark_as_advanced(DUMB_FOUND DUMB_INCLUDE_DIR DUMB_LIBRARY)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(DUMB
	REQUIRED_VARS
		DUMB_INCLUDE_DIR DUMB_LIBRARY
)

if(DUMB_FOUND AND NOT TARGET DUMB::DUMB)
    add_library(DUMB::DUMB INTERFACE IMPORTED)

	target_include_directories(DUMB::DUMB
		INTERFACE
			${DUMB_INCLUDE_DIR}
	)

	target_link_libraries(DUMB::DUMB
		INTERFACE
			${DUMB_LIBRARY}
	)
endif()
