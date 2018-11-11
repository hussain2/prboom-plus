# - Find DUMB
# Find the native DUMB includes and libraries
#
#  DUMB_INCLUDE_DIR - where to find DUMB headers.
#  DUMB_LIBRARIES   - List of libraries when using libDUMB.
#  DUMB_FOUND       - True if libDUMB found.

if(DUMB_INCLUDE_DIR)
    # Already in cache, be silent
    set(DUMB_FIND_QUIETLY TRUE)
endif(DUMB_INCLUDE_DIR)

find_path(DUMB_INCLUDE_DIR dumb.h)

find_library(DUMB_LIBRARY NAMES dumb)
if(NOT ${DUMB_LIBRARY})
   find_library(DUMB_LIBRARY NAMES libdumb)
endif(NOT ${DUMB_LIBRARY})

# Handle the QUIETLY and REQUIRED arguments and set DUMB_FOUND to TRUE if
# all listed variables are TRUE.
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(DUMB DEFAULT_MSG
    DUMB_INCLUDE_DIR DUMB_LIBRARY)

if(DUMB_FOUND)
  set(DUMB_INCLUDE_DIRS ${DUMB_INCLUDE_DIR})
  set(DUMB_LIBRARIES ${DUMB_LIBRARY})
else(DUMB_FOUND)
  set(DUMB_INCLUDE_DIRS)
  set(DUMB_LIBRARIES)
endif(DUMB_FOUND)

mark_as_advanced(DUMB_INCLUDE_DIR DUMB_LIBRARY)

if(DUMB_FOUND AND NOT TARGET DUMB::DUMB)
    add_library(DUMB::DUMB INTERFACE IMPORTED)
	
	target_include_directories(DUMB::DUMB INTERFACE "${DUMB_INCLUDE_DIRS}")
	target_link_libraries(DUMB::DUMB INTERFACE "${DUMB_LIBRARIES}")

endif()
