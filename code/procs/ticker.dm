proc/noticker()
	if (!ticker || !ticker.mode || ticker.pregame_timeleft == -1 || ticker.pregame_timeleft > 0 || ticker.current_state == GAME_STATE_PREGAME)
		return 1
	return 0