cmake_minimum_required (VERSION 3.3)

set(CMAKE_DEBUG_POSTFIX d)
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake_modules")

#############

project(PrBoom-Plus VERSION 2.5.2.0)

include(CheckIncludeFiles)
include(CheckFunctionExists)
include(CheckSymbolExists)
include(CMakeDependentOption)

#############

macro(set_if cond var)
	if (${cond})
		if (${ARGC} GREATER 2)
			set(${var} ${ARGN})
		else()
			set(${var} ${${cond}})
		endif()
	endif()
endmacro()

macro(set_if_not cond var)
	if (NOT ${cond})
		if (${ARGC} GREATER 2)
			set(${var} ${ARGN})
		else()
			set(${var} ${${cond}})
		endif()
	endif()
endmacro()

function (prepend_each prefix output)
	set(tmp ${${output}})
	FOREACH(arg IN LISTS ARGN)
		list(APPEND tmp "${prefix}${arg}")
	ENDFOREACH()
	set(${output} ${tmp} PARENT_SCOPE)
endfunction()

function (add_if_target list)
	set(tmp ${${list}})
	FOREACH(arg IN LISTS ARGN)
		if (TARGET ${arg})
			list(APPEND tmp ${arg})
		endif()
	ENDFOREACH()
	set(${list} ${tmp} PARENT_SCOPE)
endfunction()

#############

add_subdirectory (data)

find_package(SDL2 REQUIRED)
find_package(SDL2_MIXER)
find_package(SDL2_IMAGE)
find_package(SDL2_NET)
find_package(PCRE)
find_package(FLUIDSYNTH)
find_package(MAD)
find_package(PORTMIDI)
find_package(VORBIS)
find_package(DUMB)
find_package(OpenGL)

#############

set (PACKAGE_VERSION ${PROJECT_VERSION})
string(TOLOWER ${PROJECT_NAME} PACKAGE_NAME)

if(${CMAKE_BUILD_TYPE} STREQUAL Debug)
	set(DEBUG yes)
endif()

set(DOOMWADDIR data
	CACHE PATH "Path to install prboom.wad and look for other WAD files")

option(DOGS "Support MBF helper dogs" yes)
option(GL_DOOM "Support OpenGL" yes)

#############

CMAKE_DEPENDENT_OPTION(USE_SDL2_MIXER "USE_SDL2_MIXER" ON SDL2_MIXER_FOUND OFF)
CMAKE_DEPENDENT_OPTION(USE_SDL2_IMAGE "USE_SDL2_IMAGE" ON SDL2_IMAGE_FOUND OFF)
CMAKE_DEPENDENT_OPTION(USE_SDL2_NET "USE_SDL2_NET" ON SDL2_NET_FOUND OFF)
CMAKE_DEPENDENT_OPTION(USE_PCRE_PCREPOSIX "USE_PCRE_PCREPOSIX" ON PCRE_FOUND OFF)
CMAKE_DEPENDENT_OPTION(USE_FLUIDSYNTH "USE_FLUIDSYNTH" ON FLUIDSYNTH_FOUND OFF)
CMAKE_DEPENDENT_OPTION(USE_MAD "USE_MAD" ON MAD_FOUND OFF)
CMAKE_DEPENDENT_OPTION(USE_PORTMIDI "USE_PORTMIDI" ON PORTMIDI_FOUND OFF)
CMAKE_DEPENDENT_OPTION(USE_VORBIS "USE_VORBIS" ON VORBIS_FOUND OFF)
CMAKE_DEPENDENT_OPTION(USE_DUMB "USE_DUMB" ON DUMB_FOUND OFF)

#############

CMAKE_DEPENDENT_OPTION(USE_WINDOWS_LAUNCHER "Use the Windows launcher" ON WIN32 OFF)
CMAKE_DEPENDENT_OPTION(USE_WIN32_PCSOUND_DRIVER "Use PC Speaker" ON WIN32 OFF)
CMAKE_DEPENDENT_OPTION(RANGECHECK "Enable internal range checking" ON DEBUG OFF)
CMAKE_DEPENDENT_OPTION(INSTRUMENTED "Real-time memory allocation" ON DEBUG OFF)
CMAKE_DEPENDENT_OPTION(CHECKHEAP "exhaustively run memory checks while the game is running (this is EXTREMELY slow)" ON INSTRUMENTED OFF)
CMAKE_DEPENDENT_OPTION(HEAPDUMP "Generated heap dumps" ON INSTRUMENTED OFF)
CMAKE_DEPENDENT_OPTION(ZONEIDCHECK "Perform id checks on zone blocks, to detect corrupted and illegally freed blocks" ON DEBUG OFF)
CMAKE_DEPENDENT_OPTION(SIMPLECHECKS "Perform quick checks which only impose an overhead if a posible error is detected" ON DEBUG OFF)
CMAKE_DEPENDENT_OPTION(TIMEDIAG "Create time stamps each time a lump is locked. Lumps locked for long periods of time are reported" ON DEBUG OFF)
CMAKE_DEPENDENT_OPTION(USE_GLU_TESS "Use the gluTesselator" ON GL_DOOM OFF)
CMAKE_DEPENDENT_OPTION(USE_GLU_IMAGESCALE "Use gluImageScale" ON GL_DOOM OFF)
CMAKE_DEPENDENT_OPTION(USE_GLU_MIPMAP "Use gluBuild2DMipmaps" ON GL_DOOM OFF)
CMAKE_DEPENDENT_OPTION(USE_FBO_TECHNIQUE "Use FBO for some tricks in OpenGL" ON GL_DOOM OFF)
CMAKE_DEPENDENT_OPTION(USE_SHADERS "Use hardware shaders in OpenGL" ON GL_DOOM OFF)

#############

prepend_each("src/SDL/" PRBOOM_SOURCES i_main i_network i_video i_sound i_system i_joy i_sshot SDL_windows_main)
prepend_each("src/PCSOUND/" PRBOOM_SOURCES pcsound pcsound_sdl pcsound_win32)
prepend_each("src/MUSIC/" PRBOOM_SOURCES dumbplayer flplayer madplayer portmidiplayer vorbisplayer dbopl midifile opl oplplayer opl_queue)

prepend_each ("src/" PRBOOM_SOURCES
	am_map
	doomdef
	doomstat
	dstrings
	d_client
	d_deh
	d_items	
	d_main
	e6y
	e6y_launcher
	f_finale
	f_wipe
	g_game
	g_overflow
	hu_lib
	hu_stuff
	hu_tracers
	icon
	info
	i_capture
	i_pcsound
	lprintf
	md5
	memio
	mus2mid	
	m_argv
	m_bbox
	m_cheat
	m_menu
	m_misc
	m_random
	p_ceilng
	p_checksum
	p_doors
	p_enemy
	p_floor
	p_genlin
	p_inter
	p_lights
	p_map
	p_maputl
	p_mobj
	p_plats
	p_pspr
	p_saveg
	p_setup
	p_sight
	p_spec
	p_switch
	p_telept
	p_tick
	p_user
	r_bsp
	r_data
	r_demo
	r_draw
	r_filter
	r_fps
	r_main
	r_patch
	r_plane
	r_segs
	r_sky
	r_things
	sc_man
	sounds
	st_lib
	st_stuff
	s_advsound
	s_sound	
	tables
	version
	v_video
	wi_stuff
	w_mmap
	w_wad
	z_bmalloc
	z_zone
	TEXTSCREEN/txt_sdl
	hm_sin
)

prepend_each ("src/" GL_SOURCE_FILES
	gl_clipper
	gl_detail
	gl_drawinfo
	gl_fbo
	gl_gamma
	gl_hires
	gl_hqresize
	gl_light
	gl_main
	gl_map
	gl_missingtexture
	gl_opengl
	gl_preprocess
	gl_shader
	gl_shadow
	gl_sky
	gl_texture
	gl_vertex
	gl_wipe
)

set (libraries
	SDL2_MIXER::SDL2_MIXER
	SDL2_IMAGE::SDL2_IMAGE
	SDL2_NET::SDL2_NET
	PCRE::PCREPOSIX
	FLUIDSYNTH::FLUIDSYNTH
	MAD::MAD
	PORTMIDI::PORTMIDI
	VORBIS::VORBIS
	DUMB::DUMB
)

set (libraries_to_use SDL2::SDL2)

foreach(library IN LISTS libraries)
	if (TARGET ${library})
		string(REGEX REPLACE ".+::\(.+\)" "\\1" library_name ${library})
		if (NOT ${library} STREQUAL ${library_name}::${library_name})
			string(REPLACE :: _ library_name ${library})				
		endif()
	else()
		set(library_name ${library})
	endif()
	string(TOUPPER ${library_name} library_name)
	if (USE_${library_name})
		list(APPEND libraries_to_use ${library})
	endif()
endforeach()

#############

add_executable(prboom-plus
	${PRBOOM_SOURCES}
)
target_include_directories(prboom-plus
	PRIVATE ${PROJECT_BINARY_DIR} src
)
target_compile_definitions(prboom-plus
	PRIVATE HAVE_CONFIG_H=1
	PUBLIC $<$<CONFIG:DEBUG>:DEBUG=1>
)
set_target_properties(prboom-plus
	PROPERTIES DEBUG_POSTFIX -d
)
target_link_libraries(prboom-plus ${libraries_to_use})

if(GL_DOOM)
	add_executable(glboom-plus
		${GL_SOURCE_FILES}
		${PRBOOM_SOURCES}
	)
	target_include_directories(glboom-plus
		PRIVATE ${PROJECT_BINARY_DIR} src
	)
	target_compile_definitions(glboom-plus
		PRIVATE HAVE_CONFIG_H=1
		PUBLIC GL_DOOM=1 $<$<CONFIG:DEBUG>:DEBUG=1>
	)
	set_target_properties(glboom-plus
		PROPERTIES DEBUG_POSTFIX -d
	)
	target_link_libraries(glboom-plus ${libraries_to_use} OpenGL::GL OpenGL::GLU)
endif()

#############

if(USE_SDL2_NET)

	add_executable(prboom-plus_server 
		src/d_server
		src/SDL/i_system
		src/SDL/i_network
		src/SDL/SDL_windows_main
	)
	target_include_directories(prboom-plus_server
		PRIVATE ${PROJECT_BINARY_DIR} src
	)
	target_compile_definitions(prboom-plus_server
		PRIVATE HAVE_CONFIG_H=1 PRBOOM_SERVER=1
		PUBLIC $<$<CONFIG:DEBUG>:DEBUG=1>
	)
	set_target_properties(prboom-plus_server
		PROPERTIES DEBUG_POSTFIX -d
	)
	target_link_libraries(prboom-plus_server
		SDL2::SDL2
		SDL2_NET::SDL2_NET
	)
endif()

#############

check_include_files(unistd.h HAVE_UNISTD_H)
check_include_files(asm/byteorder.h HAVE_ASM_BYTEORDER_H)

check_include_files(sys/wait.h HAVE_SYS_WAIT_H)

#set(CMAKE_REQUIRED_LIBRARIES SDL2_LIBRARY) #TODO
#check_function_exists(SDL_JoystickGetAxis HAVE_SDL_JOYSTICKGETAXIS)
#message(STATUS ${HAVE_SDL_JOYSTICKGETAXIS})

check_symbol_exists(stricmp stdio.h HAVE_STRICMP)
set_if_not(HAVE_STRICMP stricmp strcasecmp)

check_symbol_exists(strnicmp stdio.h HAVE_STRNICMP)
set_if_not(HAVE_STRNICMP strnicmp strncasecmp)

check_symbol_exists(snprintf stdio.h HAVE_SNPRINTF)
set_if_not(HAVE_SNPRINTF snprintf _snprintf)

check_symbol_exists(vsnprintf stdio.h HAVE_VSNPRINTF)
set_if_not(HAVE_VSNPRINTF vsnprintf _vsnprintf)

check_symbol_exists(min stdlib.h HAVE_MIN)
set_if(HAVE_MIN MIN min)

check_symbol_exists(max stdlib.h HAVE_MAX)
set_if(HAVE_MAX MAX max)

#############

configure_file (
  "${PROJECT_SOURCE_DIR}/config.h.in"
  "${PROJECT_BINARY_DIR}/config.h"
  )
