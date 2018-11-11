cmake_minimum_required (VERSION 3.3)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake_modules")

#############

project(PrBoom-Plus VERSION 2.5.1.5)

include(CheckSymbolExists)
include(CMakeDependentOption)

#############

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

option(DOOMWADDIR "Path to install prboom.wad and look for other WAD files" data)

if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/data/graphics/m_generl.ppm")
	set(have_nonfree_graphics yes)
endif()

option(dogs "support for helper dogs" yes)
option(GL_DOOM "Define if you are building with OpenGL support" yes)

#############

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

CMAKE_DEPENDENT_OPTION(nonfree_graphics "build prboom.wad with non-free lumps" ON have_nonfree_graphics OFF)
CMAKE_DEPENDENT_OPTION(USE_SDL_NET "Networkg support" ON SDL2_NET_FOUND OFF)

#############

prepend_each("src/SDL/" PRBOOM_SOURCES i_main i_network i_video i_sound i_system i_joy i_sshot SDL_windows_main)
prepend_each("src/PCSOUND/" PRBOOM_SOURCES pcsound pcsound_sdl pcsound_win32)
prepend_each("src/MUSIC/" PRBOOM_SOURCES dumbplayer flplayer madplayer portmidiplayer vorbisplayer dbopl midifile opl oplplayer opl_queue)

set(music_sources)

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

set (LIBS SDL2::SDL2)

add_if_target(LIBS
	SDL2_MIXER::SDL2_MIXER
	SDL2_IMAGE::SDL2_IMAGE
	SDL2_NET::SDL2_NET
	PCRE::PCRE
	FLUIDSYNTH::FLUIDSYNTH
	MAD::MAD
	PORTMIDI::PORTMIDI
	VORBIS::VORBIS
	DUMB::DUMB
)

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
target_link_libraries(prboom-plus ${LIBS})

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
	target_link_libraries(glboom-plus ${LIBS} OpenGL::GL OpenGL::GLU)
endif()

#############

if(USE_SDL_NET)

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
	target_link_libraries(prboom-plus_server 
		SDL2::SDL2
		SDL2_NET::SDL2_NET
	)
endif()

#############

configure_file (
  "${PROJECT_SOURCE_DIR}/config.h.in"
  "${PROJECT_BINARY_DIR}/config.h"
  )
