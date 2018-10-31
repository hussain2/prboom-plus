cmake_minimum_required (VERSION 3.0)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake_modules")

#############

project (PrBoom-Plus VERSION 2.5.1.5)

add_library(${PROJECT_NAME} INTERFACE)

target_include_directories(${PROJECT_NAME}
	INTERFACE src ${PROJECT_BINARY_DIR}
)

target_compile_definitions(${PROJECT_NAME}
	INTERFACE HAVE_CONFIG_H=1 $<$<CONFIG:DEBUG>:DEBUG=1>
)

#############

#[[
function(find_package name)
	string(TOLOWER "${name}" name_lower)
	if ("${name_lower}" STREQUAL ${PACKAGE_NAME})
	else()
		_find_pacakge(${ARGV})
	endif()	
endfunction()
#]]

find_package(SDL2)
find_package(SDL2_MIXER)
find_package(SDL2_IMAGE)
find_package(SDL2_NET)
#find_package(PCRE)
find_package(FLUIDSYNTH)
#find_package(MAD)
#find_package(PORTMIDI)
#find_package(VORBIS)
#find_package(DUMB)

##
#[[
target_link_libraries(${PROJECT_NAME} INTERFACE
	SDL2::SDL2 SDL2_MIXER::SDL2_MIXER SDL2_IMAGE::SDL2_IMAGE
	PCRE::PCRE FLUIDSYNTH::FLUIDSYNTH MAD::MAD PORTMIDI::PORTMIDI VORBIS::VORBIS 
#	DUMB::DUMB
)
#]]

target_link_libraries(${PROJECT_NAME} INTERFACE
	SDL2::SDL2
	#SDL2_MIXER::SDL2_MIXER
	#SDL2_IMAGE::SDL2_IMAGE
	#PCRE::PCRE
	#FLUIDSYNTH::FLUIDSYNTH
	#MAD::MAD PORTMIDI
	#VORBIS::VORBIS
#	DUMB
)

#############

set (PACKAGE_VERSION ${PROJECT_VERSION})
string(TOLOWER ${PROJECT_NAME} PACKAGE_NAME)


option(DOOMWADDIR "Path to install prboom.wad and look for other WAD files" data)

if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/data/graphics/m_generl.ppm")
	set(have_nonfree_graphics yes)
endif()

option(nonfree_graphics "build prboom.wad with non-free lumps" yes)
option(dogs "support for helper dogs" yes)

option(GL_DOOM "Define if you are building with OpenGL support" yes)


#############

include (CheckSymbolExists)

macro(check_symbol_not_exists func inc symb)
	check_symbol_exists(${func} ${inc} ${func}_FOUND)	
	if (NOT ${func}_FOUND)
		if (${ARGC} GREATER 3)
			set(${symb} ${ARGN})
		else()
			set(${symb} 1)
		endif()
	endif()
	#message(STATUS "${func}_FOUND: ${${func}_FOUND} ${ARGC}")
endmacro()

macro(set_if cond var)
	if (${cond})
		if (${ARGC} GREATER 2)
			set(${var} ${ARGN})
		else()
			set(${var} ${${cond}})
		endif()
	endif()
endmacro()

macro(set_if_not cond)
	set_if("NOT ${cond}" ${ARGN})
endmacro()

set_if(SDL2_MIXER_FOUND HAVE_LIBSDL2_MIXER)
set_if(SDL2_IMAGE_FOUND HAVE_LIBSDL2_IMAGE)
set_if(PCRE_FOUND HAVE_LIBPCREPOSIX)
set_if(FLUIDSYNTH_FOUND HAVE_LIBFLUIDSYNTH)
set_if(MAD_FOUND HAVE_LIBMAD)
set_if(PORTMIDI_FOUND HAVE_LIBPORTMIDI)
set_if(VORBIS_FOUND HAVE_LIBVORBISFILE)
set_if(DUMB_FOUND HAVE_LIBDUMB)

check_symbol_not_exists(snprintf stdio.h "snprintf")
check_symbol_not_exists(vsnprintf stdio.h "vsnprintf" )

#############

add_subdirectory (src)
add_subdirectory (data)

file(WRITE null.cpp)
add_executable(${PACKAGE_NAME} null.cpp)

target_include_directories(${PACKAGE_NAME} INTERFACE ${PROJECT_NAME})
target_link_libraries(${PACKAGE_NAME} ${PROJECT_NAME}
libsdldoom
libdoommusic 
libtextscreen
libpcsound
src_objs
SDL2::SDL2
SDL2_MIXER::SDL2_MIXER
SDL2_IMAGE::SDL2_IMAGE
SDL2_NET::SDL2_NET
FLUIDSYNTH::FLUIDSYNTH
)

#############

configure_file (
  "${PROJECT_SOURCE_DIR}/config.h.in"
  "${PROJECT_BINARY_DIR}/config.h"
  )
