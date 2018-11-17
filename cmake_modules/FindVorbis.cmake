# FindVorbis.cmake
#
# Finds the rapidjson library
#
# This will define the following variables
#
#    VORBIS_FOUND
#
# and the following imported targets
#
#     VORBIS::VORBIS
#
# Author: Hussain AlMutawa - hussain.ali.almutawa@gmail.com

find_path(OGG_INCLUDE_DIR ogg/ogg.h)
find_path(VORBIS_INCLUDE_DIR vorbis/vorbisfile.h)
    
find_library(OGG_LIBRARY ogg)
find_library(VORBIS_LIBRARY vorbis)
find_library(VORBISFILE_LIBRARY vorbisfile)

mark_as_advanced(VORBIS_FOUND OGG_INCLUDE_DIR VORBIS_INCLUDE_DIR OGG_LIBRARY VORBIS_LIBRARY VORBISFILE_LIBRARY)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(VORBIS
	REQUIRED_VARS
		OGG_INCLUDE_DIR VORBIS_INCLUDE_DIR OGG_LIBRARY VORBIS_LIBRARY VORBISFILE_LIBRARY
)

if(VORBIS_FOUND AND NOT TARGET VORBIS::VORBIS)
    add_library(VORBIS::VORBIS INTERFACE IMPORTED)
	
	set(VORBIS_INCLUDE_DIRS ${OGG_INCLUDE_DIR} ${VORBIS_INCLUDE_DIR})
	list(REMOVE_DUPLICATES VORBIS_INCLUDE_DIRS)

	target_include_directories(VORBIS::VORBIS
		INTERFACE
			${VORBIS_INCLUDE_DIRS}
	)

	set(VORBIS_INCLUDE_DIRS)
	
	target_link_libraries(VORBIS::VORBIS
		INTERFACE
			${OGG_LIBRARY} ${VORBIS_LIBRARY} ${VORBISFILE_LIBRARY}
	)

endif()
