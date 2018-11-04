
add_subdirectory (POSIX)

my_find_package(SDL2)

function (prepend_each prefix output)
	set(tmp)
	FOREACH(arg IN LISTS ARGN)
		list(APPEND tmp "${prefix}${arg}")
	ENDFOREACH()
	set(${output} ${tmp} PARENT_SCOPE)
endfunction()


prepend_each("SDL/" SDL_SOURCES i_main i_network i_video i_sound i_system i_joy i_sshot	SDL_windows_main)
prepend_each("PCSOUND/" PCSOUND_SOURCES pcsound pcsound_sdl	pcsound_win32)
prepend_each("MUSIC/" MUSIC_SOURCES dbopl dumbplayer flplayer madplayer midifile opl oplplayer opl_queue portmidiplayer vorbisplayer)

set (SOURCE_FILES

	am_map.c
	doomdef.c
	doomstat.c
	dstrings.c
	d_client.c
	d_deh.c
	#d_ipxgate.c # linux
	d_items.c
	d_main.c
	d_server.c
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
	w_memcache.c
	w_mmap.c
	w_wad.c
	z_bmalloc.c
	z_zone.c

	TEXTSCREEN/txt_sdl.c
)

add_library(src_objs STATIC 
	${SOURCE_FILES}
	${SDL_SOURCES}
	${PCSOUND_SOURCES}
	${MUSIC_SOURCES}
)

add_library(gl_objs STATIC
	${SOURCE_FILES}
	${SDL_SOURCES}
	${PCSOUND_SOURCES}
	${MUSIC_SOURCES}

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

target_include_directories(src_objs PUBLIC .)
target_link_libraries(src_objs ${PROJECT_NAME})

target_include_directories(gl_objs PUBLIC .)
target_link_libraries(gl_objs ${PROJECT_NAME})

target_compile_definitions(gl_objs PUBLIC GL_DOOM=1)