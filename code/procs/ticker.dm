proc/noticker()
	if (!ticker || !ticker.mode || ticker.pregame_timeleft == -1 || ticker.pregame_timeleft > 0)
		return 1
	return 0