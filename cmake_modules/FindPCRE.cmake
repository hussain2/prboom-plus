# - Find pcre
# Find the native PCRE headers and libraries.
#
# PCRE_INCLUDE_DIRS	- where to find pcre.h, etc.
# PCRE_LIBRARIES	- List of libraries when using pcre.
# PCRE_FOUND	- True if pcre found.

# Look for the header file.
FIND_PATH(PCRE_INCLUDE_DIR NAMES pcre.h)

# Look for the library.
FIND_LIBRARY(PCRE_LIBRARY NAMES pcre)
FIND_LIBRARY(PCRE16_LIBRARY NAMES pcre16)
FIND_LIBRARY(PCRE32_LIBRARY NAMES pcre32)
FIND_LIBRARY(PCRECPP_LIBRARY NAMES pcrecpp)
FIND_LIBRARY(PCREPOSIX_LIBRARY NAMES pcreposix)

# Handle the QUIETLY and REQUIRED arguments and set PCRE_FOUND to TRUE if all listed variables are TRUE.
INCLUDE(FindPackageHandleStandardArgs)
find_package_handle_standard_args(PCRE DEFAULT_MSG PCRE_LIBRARY PCRE_INCLUDE_DIR PCRE16_LIBRARY PCRE32_LIBRARY PCRECPP_LIBRARY PCREPOSIX_LIBRARY)

# Copy the results to the output variables.
IF(PCRE_FOUND)
	SET(PCRE_LIBRARIES ${PCRE_LIBRARY} ${PCRE16_LIBRARY} ${PCRE32_LIBRARY} ${PCRECPP_LIBRARY} ${PCREPOSIX_LIBRARY})
	SET(PCRE_INCLUDE_DIRS ${PCRE_INCLUDE_DIR})
ELSE(PCRE_FOUND)
	SET(PCRE_LIBRARIES)
	SET(PCRE_INCLUDE_DIRS)
ENDIF(PCRE_FOUND)

MARK_AS_ADVANCED(PCRE_INCLUDE_DIRS PCRE_LIBRARIES)

if(PCRE_FOUND AND NOT TARGET PCRE::PCRE)
    add_library(PCRE::PCRE INTERFACE IMPORTED)
	
	target_include_directories(PCRE::PCRE INTERFACE "${PCRE_INCLUDE_DIRS}")
	target_link_libraries(PCRE::PCRE INTERFACE "${PCRE_LIBRARIES}")

endif()
