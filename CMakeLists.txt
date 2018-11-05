cmake_minimum_required (VERSION 3.3)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake_modules")

#############

project (PrBoom-Plus VERSION 2.5.1.5)

include (CheckSymbolExists)

#############

#set(as_subproject LOG)

macro(my_find_package)
#	if (NOT "${ARGV0}" IN_LIST as_subproject)
#		message("my_find_package:- calling find_package(${ARGV})")
		find_package(${ARGV})
#	endif()
#	message("my_find_package:- done")
endmacro()

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
	set(tmp)
	FOREACH(arg IN LISTS ARGN)
		list(APPEND tmp "${prefix}${arg}")
	ENDFOREACH()
	set(${output} ${tmp} PARENT_SCOPE)
endfunction()

#############

add_subdirectory (data)

my_find_package(SDL2)
my_find_package(SDL2_MIXER)
my_find_package(SDL2_IMAGE)
my_find_package(SDL2_NET)
#my_find_package(PCRE)
my_find_package(FLUIDSYNTH)
#my_find_package(MAD)
#my_find_package(PORTMIDI)
#my_find_package(VORBIS)
#my_find_package(DUMB)
my_find_package(OpenGL)


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

prepend_each("src/SDL/" SDL_SOURCES i_main i_network i_video i_sound i_system i_joy i_sshot	SDL_windows_main)
prepend_each("src/PCSOUND/" PCSOUND_SOURCES pcsound pcsound_sdl	pcsound_win32)
prepend_each("src/MUSIC/" MUSIC_SOURCES dbopl dumbplayer flplayer madplayer midifile opl oplplayer opl_queue portmidiplayer vorbisplayer)

prepend_each ("src/" SOURCE_FILES
	am_map.c
	doomdef.c
	doomstat.c
	dstrings.c
	d_client.c
	d_deh.c
	#d_ipxgate.c # linux
	d_items.c
	d_main.c
	e6y.c
	e6y_launcher.c
	f_finale.c
	f_wipe.c
	g_game.c
	g_overflow.c
	hu_lib.c
	hu_stuff.c
	hu_tracers.c
	icon.c
	info.c
	i_capture.c
	i_pcsound.c
	lprintf.c
	md5.c
	memio.c
	mus2mid.c
	m_argv.c
	m_bbox.c
	m_cheat.c
	m_menu.c
	m_misc.c
	m_random.c
	p_ceilng.c
	p_checksum.c
	p_doors.c
	p_enemy.c
	p_floor.c
	p_genlin.c
	p_inter.c
	p_lights.c
	p_map.c
	p_maputl.c
	p_mobj.c
	p_plats.c
	p_pspr.c
	p_saveg.c
	p_setup.c
	p_sight.c
	p_spec.c
	p_switch.c
	p_telept.c
	p_tick.c
	p_user.c
	r_bsp.c
	r_data.c
	r_demo.c
	r_draw.c
	r_filter.c
	r_fps.c
	r_main.c
	r_patch.c
	r_plane.c
	r_segs.c
	r_sky.c
	r_things.c
	sc_man.c
	sounds.c
	st_lib.c
	st_stuff.c
	s_advsound.c
	s_sound.c
	tables.c
	version.c
	v_video.c
	wi_stuff.c
	w_mmap.c
	w_wad.c
	z_bmalloc.c
	z_zone.c
	TEXTSCREEN/txt_sdl.c
)

list(APPEND SOURCE_FILES
	${SDL_SOURCES}
	${PCSOUND_SOURCES}
	${MUSIC_SOURCES}
)

prepend_each ("src/" GL_SOURCE_FILES
	gl_clipper.c
	gl_detail.c
	gl_drawinfo.c
	gl_fbo.c
	gl_gamma.c
	gl_hires.c
	gl_hqresize.c
	gl_light.c
	gl_main.c
	gl_map.c
	gl_missingtexture.c
	gl_opengl.c
	gl_preprocess.c
	gl_shader.c
	gl_shadow.c
	gl_sky.c
	gl_texture.c
	gl_vertex.c
	gl_wipe.c
)

set (LIBS 
	SDL2::SDL2
	SDL2_MIXER::SDL2_MIXER
	SDL2_IMAGE::SDL2_IMAGE
	SDL2_NET::SDL2_NET
	FLUIDSYNTH::FLUIDSYNTH
)

#############

add_executable(prboom-plus 
	${SOURCE_FILES}
)

add_executable(glboom-plus 
	${GL_SOURCE_FILES}
	${SOURCE_FILES}
)

##
target_include_directories(prboom-plus
	PRIVATE ${PROJECT_BINARY_DIR} src
)
target_compile_definitions(prboom-plus
	PRIVATE HAVE_CONFIG_H=1
	PUBLIC $<$<CONFIG:DEBUG>:DEBUG=1>
)
target_link_libraries(prboom-plus ${LIBS})

##
target_include_directories(glboom-plus
	PRIVATE ${PROJECT_BINARY_DIR} src
)
target_compile_definitions(glboom-plus
	PRIVATE HAVE_CONFIG_H=1
	PUBLIC GL_DOOM=1 $<$<CONFIG:DEBUG>:DEBUG=1>
)
target_link_libraries(glboom-plus ${LIBS} OpenGL::GL OpenGL::GLU)

#############

configure_file (
  "${PROJECT_SOURCE_DIR}/config.h.in"
  "${PROJECT_BINARY_DIR}/config.h"
  )
