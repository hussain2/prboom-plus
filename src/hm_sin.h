#pragma once

#include<d_player.h>

typedef struct {
	int delay;
	int damage;
	int punishing;
	int prev_health;
} hm_sin_state_t;

hm_sin_state_t hm_sin_state[MAXPLAYERS];

void hm_sin_think(player_t* player);

int hm_is_sinner(player_t *player);
void hm_add_sin(player_t *player, int damage);
#define hm_add_3_sin(player,damage) hm_add_sin(player,(damage)*3)

int hm_sin; 

