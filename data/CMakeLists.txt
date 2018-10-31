
add_executable(rdatawad
	rd_main.c
	rd_util.c rd_util.h
	rd_output.c rd_output.h
	rd_sound.c rd_sound.h
	rd_palette.c rd_palette.h
	rd_graphic.c rd_graphic.h
)

target_include_directories(rdatawad PUBLIC ${PROJECT_NAME})
target_link_libraries(rdatawad PUBLIC ${PROJECT_NAME})

add_custom_target(prboom_wad DEPENDS prboom-plus.wad)

function(file_lists var dir ext)

	set(filenames ${${var}})
	set(filepaths ${${var}_PATHS})

	if (${dir} MATCHES "[^/\\]$")
		set(dir "${dir}/")
	endif()

	foreach(arg IN LISTS ARGN)
		string(REGEX MATCH "^[0-9]+,[0-9]+," pos ${arg})
		string(REGEX REPLACE "^[0-9]+,[0-9]+," "" arg ${arg})
		set(filename "${dir}${arg}.${ext}")
		list(APPEND filenames "${filename}")
		list(APPEND filepaths "${pos}${filename}")
	endforeach(arg)

	set(${var} ${filenames} PARENT_SCOPE)
	set("${var}_PATHS" ${filepaths} PARENT_SCOPE)
	
endfunction(file_lists)

set(_PALETTE palette)
set(_LUMPS switches animated crbrick crtan crgray crgreen crbrown crgold crred crblue crblue2 crorange cryellow)
set(_COLORMAPS watermap)
set(_TABLES sinetabl tangtabl tantoang gammatbl chexdeh bfgbex nervebex glshadow glfp glvp -prbhud- m_ammo m_armour m_arrow m_health m_key m_normal m_shadow m_power m_weap m_mark)
set(_SOUNDS )
set(_GRAPHICS dig0 dig1 dig2 dig3 dig4 dig5 dig6 dig7 dig8 dig9 diga digb digc digd dige digf digg digh digi digj digk digl digm dign digo digp digq digr digs digt digu digv digw digx digy digz dig45 dig47 dig58 dig91 dig93 stbr123 stbr124 stbr125 stbr126 stbr127 boxul boxuc boxur boxcl boxcc boxcr boxll boxlc boxlr stkeys6 stkeys7 stkeys8 stcfn096 m_butt1 m_butt2 m_colors m_palno m_palsel m_vbox cross1 cross2 cross3)
set(_FLATS -n0_tex-)
set(_SPRITES )

set(TNT_SPRITES 0,0,tnt1a0)
set(NONFREE_SOUNDS dssecret dsgibdth)
set(NONFREE_GRAPHICS m_generl m_setup m_auto m_keybnd m_chat m_compat m_enem m_mess m_stat m_weap m_horsen m_versen prboom m_accel m_loksen)
set(NONFREE_SPRITES 8,12,pls1a0 9,12,pls1b0 8,12,pls1c0 9,12,pls1d0 25,37,pls1e0 25,37,pls1f0 26,42,pls1g0 7,10,pls2a0 6,8,pls2b0 5,6,pls2c0 7,10,pls2d0 11,16,pls2e0)

set(DOG_SOUNDS dsdgsit dsdgatk dsdgact dsdgdth dsdgpain)
set(NONFREE_DOG_SPRITES 32,59,dogsd5 32,59,dogsh5 32,59,dogsc5 32,59,dogsg5 32,59,dogsb1 32,59,dogsa5 32,59,dogse5 32,59,dogsc1 32,59,dogsd1 32,59,dogsb5 32,59,dogsf5 32,59,dogsa1 32,59,dogse1 32,59,dogsf1 32,59,dogsd2d8 32,59,dogsh2 32,59,dogsg1 32,59,dogsh8 32,59,dogse8 32,59,dogsd4d6 32,59,dogsh4 32,59,dogsa2a8 32,59,dogse2 32,59,dogsf8 32,59,dogsh1 32,59,dogsa4a6 32,59,dogse4 32,59,dogsb4b6 32,59,dogsf4 32,59,dogsh6 32,59,dogsb2b8 32,59,dogsf2 32,59,dogsc2c8 32,59,dogsg2 32,59,dogsg6 32,59,dogsc4c6 32,59,dogsg4 32,59,dogsg8 32,59,dogsf6 32,59,dogsn0 32,59,dogse6 32,59,dogsd3d7 32,59,dogsh3 32,59,dogsh7 32,59,dogsi0 32,59,dogsa3a7 32,59,dogse3 32,59,dogsb3b7 32,59,dogsf3 32,59,dogsf7 32,59,dogse7 32,59,dogsc3c7 32,59,dogsg3 32,59,dogsg7 32,59,dogsj0 32,59,dogsk0 32,59,dogsl0 32,59,dogsm0)
set(FREE_DOG_SPRITES 10,30,dogsa1 14,29,dogsa2a8 15,29,dogsa3a7 12,29,dogsa4a6 10,30,dogsa5 9,30,dogsb1 13,29,dogsb2b8 14,29,dogsb3b7 12,29,dogsb4b6 9,29,dogsb5 10,30,dogsc1 11,29,dogsc2c8 14,29,dogsc3c7 12,29,dogsc4c6 10,30,dogsc5 10,30,dogsd1 12,29,dogsd2d8 14,29,dogsd3d7 13,29,dogsd4d6 9,29,dogsd5 10,30,dogse1 14,29,dogse2 14,29,dogse3 13,29,dogse4 9,29,dogse5 13,29,dogse6 14,29,dogse7 14,29,dogse8 10,30,dogsf1 13,29,dogsf2 16,29,dogsf3 13,29,dogsf4 9,28,dogsf5 13,29,dogsf6 16,29,dogsf7 13,29,dogsf8 9,30,dogsg1 12,29,dogsg2 13,29,dogsg3 11,29,dogsg4 8,28,dogsg5 11,29,dogsg6 13,29,dogsg7 12,29,dogsg8 9,25,dogsh1 10,26,dogsh2 11,26,dogsh3 11,26,dogsh4 9,26,dogsh5 11,26,dogsh6 11,26,dogsh7 10,26,dogsh8 10,30,dogsi0 10,30,dogsj0 11,27,dogsk0 11,20,dogsl0 12,15,dogsm0 13,15,dogsn0)

if(${dogs})
	list(APPEND _SOUNDS ${DOG_SOUNDS})
	if(${nonfree_graphics})
		list(APPEND _SPRITES ${NONFREE_DOG_SPRITES})
	else()
		list(APPEND _SPRITES ${FREE_DOG_SPRITES})
	endif()
endif()

if(${nonfree_graphics})
	set(sound_dir sounds)
	set(sprite_dir sprites)
	list(APPEND _SOUNDS ${NONFREE_SOUNDS})
	list(APPEND _GRAPHICS ${NONFREE_GRAPHICS})
	list(APPEND _SPRITES ${NONFREE_SPRITES})
else()
	set(sound_dir sounds/free)
	set(sprite_dir sprites/free)
endif()

file_lists(PALETTE "" rgb ${_PALETTE})
file_lists(LUMPS lumps lmp ${_LUMPS})
file_lists(COLORMAPS lumps lmp ${_COLORMAPS})
file_lists(TABLES lumps lmp ${_TABLES})
file_lists(SOUNDS ${sound_dir} wav ${_SOUNDS})
file_lists(GRAPHICS graphics ppm ${_GRAPHICS})
file_lists(FLATS flats ppm ${_FLATS})

file_lists(SPRITES sprites ppm ${TNT_SPRITES})
file_lists(SPRITES ${sprite_dir} ppm ${_SPRITES})

add_custom_command(
	OUTPUT prboom-plus.wad
	COMMAND rdatawad
		-I ${CMAKE_CURRENT_SOURCE_DIR}
		-palette ${PALETTE_PATHS}
		-lumps ${LUMPS_PATHS}
		-marker C_START -lumps ${COLORMAPS_PATHS} -marker C_END
		-marker B_START -lumps ${TABLES_PATHS} -marker B_END
		-sounds ${SOUNDS_PATHS}
		-graphics ${GRAPHICS_PATHS}
		-marker FF_START -flats ${FLATS_PATHS} -marker FF_END
		-marker SS_START -sprites ${SPRITES_PATHS} -marker SS_END
		-o prboom-plus.wad
	DEPENDS rdatawad ${PALETTE} ${LUMPS} ${COLORMAPS} ${TABLES} ${SOUNDS} ${GRAPHICS} ${FLATS} ${SPRITES}
	COMMENT "Generating prboom-plus.wad"
)

