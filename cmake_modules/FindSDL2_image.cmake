# Locate SDL2_image library
# This module defines
# SDL2_IMAGE_LIBRARIES, the name of the library to link against
# SDL2_IMAGE_FOUND, if false, do not try to link to SDL2_image
# SDL2_IMAGE_INCLUDE_DIR, where to find SDL_image.h

# $SDL2 is an environment variable that would
# correspond to the ./configure --prefix=$SDL2
# used in building SDL2.
# l.e.galup 9-20-02
#
# Modified by Hussain AlMutawa. Added target definition.
#
# Modified by Eric Wing.
# Ported by Johnny Patterson. Unix paths. environmental variables. OS X frameworks. MinGW.
#
# On OSX, this will prefer the Framework version (if found) over others.
# People will have to manually change the cache values of
# SDL2_IMAGE_LIBRARY to override this selection or set the CMake environment
# CMAKE_INCLUDE_PATH to modify the search paths.
#
# Note that the header path has changed from SDL2/SDL.h to just SDL.h
# This needed to change because "proper" SDL2 convention
# is #include "SDL.h", not <SDL.h>. This is done for portability
# reasons because not all systems place things in SDL2/ (see FreeBSD).
#

# 
# Note that on windows this will only search for the 32bit libraries, to search
# for 64bit change x86/i686-w64 to x64/x86_64-w64

#=============================================================================
# Copyright 2003-2009 Kitware, Inc.
#
# CMake - Cross Platform Makefile Generator
# Copyright 2000-2014 Kitware, Inc.
# Copyright 2000-2011 Insight Software Consortium
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# * Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
#
# * Redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution.
#
# * Neither the names of Kitware, Inc., the Insight Software Consortium,
# nor the names of their contributors may be used to endorse or promote
# products derived from this software without specific prior written
# permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# (To distribute this file outside of CMake, substitute the full
# License text for the above reference.)

FIND_PATH(SDL2_IMAGE_INCLUDE_DIR SDL_image.h
	HINTS
	${SDL2}
	$ENV{SDL2}
	$ENV{SDL2_IMAGE}
	PATH_SUFFIXES include/SDL2 include SDL2
	i686-w64-mingw32/include/SDL2
	x86_64-w64-mingw32/include/SDL2
	PATHS
	~/Library/Frameworks
	/Library/Frameworks
	/usr/local/include/SDL2
	/usr/include/SDL2
	/sw # Fink
	/opt/local # DarwinPorts
	/opt/csw # Blastwave
	/opt
)

if(CMAKE_SIZEOF_VOID_P EQUAL 8)
  # Lookup the 64 bit libs on x64
  set(VC_LIB_PATH_SUFFIX lib64 lib lib/x64 x86_64-w64-mingw32/lib)
else()
  # On 32bit build find the 32bit libs
  set(VC_LIB_PATH_SUFFIX lib lib/x86 i686-w64-mingw32/lib)
endif()

FIND_LIBRARY(SDL2_IMAGE_LIBRARY
	NAMES SDL2_image
	HINTS
	${SDL2}
	$ENV{SDL2}
	$ENV{SDL2_IMAGE}
	PATH_SUFFIXES
	${VC_LIB_PATH_SUFFIX}
	PATHS
	/sw
	/opt/local
	/opt/csw
	/opt
)

SET(SDL2_IMAGE_LIBRARIES ${SDL2_IMAGE_LIBRARY})

INCLUDE(FindPackageHandleStandardArgs)

FIND_PACKAGE_HANDLE_STANDARD_ARGS(SDL2_IMAGE REQUIRED_VARS SDL2_IMAGE_LIBRARY SDL2_IMAGE_INCLUDE_DIR)

if(SDL2_IMAGE_FOUND AND NOT TARGET SDL2_IMAGE::SDL2_IMAGE)
    add_library(SDL2_IMAGE::SDL2_IMAGE INTERFACE IMPORTED)
	
	target_include_directories(SDL2_IMAGE::SDL2_IMAGE
		INTERFACE
			${SDL2_IMAGE_INCLUDE_DIR}
	)

	target_link_libraries(SDL2_IMAGE::SDL2_IMAGE
		INTERFACE
			${SDL2_IMAGE_LIBRARIES}
	)

endif()
