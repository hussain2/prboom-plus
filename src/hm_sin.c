#include<doomstat.h>
#include<p_inter.h>
#include<p_tick.h>
#include<lprintf.h>
#include "hm_sin.h"
 
 
int effective_health(player_t *player) {
	int h = player->health, a = player->armorpoints, t = player->armortype;

	if (!t) return h;

	return h + MIN(t == 1 ? h/2: h, a);	
}

hm_sin_state_t *hm_get_sin_state(player_t *player) {
	int playerno = player - players;

	if (playerno < 0 || playerno > MAXPLAYERS) {
		lprintf(LO_ERROR, "hm_get_sin_state: player pointer out of range");
		return NULL;
	}

	return &hm_sin_state[playerno];
}

int hm_is_sinner(player_t *player) {
	if (!hm_sin) return 0;
	hm_sin_state_t *sin_state = hm_get_sin_state(player);
	return sin_state->damage;
}

void hm_add_sin(player_t *player, int damage) {
	hm_sin_state_t *sin_state;

	if (damage <= 0) return;

	sin_state = hm_get_sin_state(player);

	sin_state->damage += damage;
	sin_state->prev_health = effective_health(player);

	if (!sin_state->punishing)
		sin_state->delay = 100;
}

#define GREAD_MSG "Don't be gready!, %d pending damage."

void hm_sin_think(player_t* player) {
	int i, hd, kill;
	hm_sin_state_t *sin_state = hm_get_sin_state(player);
	
	static char msg[sizeof(GREAD_MSG) + 4];

	if (sin_state->delay && !--sin_state->delay) {

		sin_state->delay = 75;
		sin_state->punishing = 1;

		hd = effective_health(player) - sin_state->prev_health;

		if (hd < 0)
			sin_state->damage += hd;

		kill = sin_state->damage >= 1000;

		if (sin_state->damage > 0) {
			if (kill) {
				P_DamageMobj(player->mo, NULL, NULL, sin_state->damage);
				player->message = "You don't learn. Do you? Just DIE!!";
			} else {
				i = sin_state->damage > 25 ? sin_state->damage > 75 ? 5 : 3 : 1;
				player->message = msg;
			}
		} else {
			i = 0;
		}

		if (kill || (sin_state->damage -= i * 3) <= 0) {
			sin_state->damage = 0;
			sin_state->delay = 0;
			sin_state->punishing = 0;
		}

		 if (!kill) {
			while (i--)
				P_DamageMobj(player->mo, NULL, NULL, 3);
			sprintf(msg, GREAD_MSG, sin_state->damage);
		}
		
		sin_state->prev_health = effective_health(player);
	}
}

