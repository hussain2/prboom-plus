
add_subdirectory (SDL)
add_subdirectory (PCSOUND)
add_subdirectory (TEXTSCREEN)
add_subdirectory (POSIX)
add_subdirectory (MUSIC)

find_package(SDL2)

add_library(src_objs STATIC 
am_map.c
doomdef.c
doomstat.c
dstrings.c
d_client.c
d_deh.c
#d_ipxgate.c
d_items.c
d_main.c
d_server.c
e6y.c
e6y_launcher.c
f_finale.c
f_wipe.c
gl_clipper.c
#gl_detail.c
#gl_drawinfo.c
#gl_fbo.c
#gl_gamma.c
#gl_hires.c
#gl_hqresize.c
#gl_light.c
#gl_main.c
#gl_map.c
#gl_missingtexture.c
gl_opengl.c
gl_preprocess.c
#gl_shader.c
#gl_shadow.c
#gl_sky.c
#gl_texture.c
gl_vertex.c
gl_wipe.c
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
)

target_include_directories(src_objs INTERFACE ${PROJECT_NAME})
target_link_libraries(src_objs ${PROJECT_NAME})
