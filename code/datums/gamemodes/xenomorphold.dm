/datum/game_mode/xenomorph
	name = "xenomorph"
	config_tag = "xenomorph"
	latejoin_antag_compatible = 0
//	latejoin_antag_roles = list("xenomorph")

	var/const/xenomorphs_possible = 5

	var/game_start_realtime
	var/game_end_realtime
	var/game_ends_at_realtime = 72000//2 hours by default


//	var/token_players_assigned = 0

//	var/const/waittime_l = 600 //lower bound on time before intercept arrives (in tenths of seconds)
//	var/const/waittime_h = 1800 //upper bound on time before intercept arrives (in tenths of seconds)

	votable = 1
	crew_shortage_enabled = 0
	shuttle_available = 0



/datum/game_mode/xenomorph/pre_setup()
	var/players_needed = 2
	var/num_players = 0
	for(var/mob/new_player/player in mobs)
		if(player.client && player.ready) num_players++
		else if(player.fake_client && player.ready) num_players++

	boutput(world, "[num_players] players")

	boutput(world, "Oh fuck gets to cp zero")

	if (num_players < players_needed)
		boutput(world, "<B>Not enough players readied to run gamemode Alien Infestation.([players_needed] players needed)</B>")
		return 0

	var/i = rand(5)
	var/num_xenomorphs = max(1, min(round((num_players + i) / 15), xenomorphs_possible))

	boutput(world, "Oh fuck gets to cp 0.5")

	if (num_xenomorphs > num_players/2)
		num_xenomorphs = round(num_players/2)//with the minimum of two players, this means one xeno

	boutput(world, "Oh fuck gets to cp 0.7")

	var/list/possible_xenomorphs = get_possible_xenomorphs(num_xenomorphs)

	boutput(world, "Oh fuck gets to cp 0.9")

	if (num_xenomorphs > possible_xenomorphs.len)
		num_xenomorphs = possible_xenomorphs.len

	boutput(world, "Oh fuck gets to cp 0.95")

	if (possible_xenomorphs.len)
		boutput(world, "first possible xenomorph is [possible_xenomorphs[1]]")
	boutput(world, "Oh fuck gets to cp 0.97")
	if (!possible_xenomorphs.len)
		boutput(world, "<B>Not enough players had Alien toggled to run gamemode Alien Infestation.([players_needed/2] alien(s) needed)</B>")
		return 0
	boutput(world, "Oh fuck gets to cp 0.99")
	//error should be before this
	boutput(world, "Oh fuck gets to cp one")
/*
	token_players = antag_token_list()
	for(var/datum/mind/tplayer in token_players)
		if (!token_players.len)
			break
		src.traitors += tplayer
		token_players.Remove(tplayer)
		logTheThing("admin", tplayer.current, null, "successfully redeems an antag token.")
		message_admins("[key_name(tplayer.current)] successfully redeems an antag token.")
		//num_changelings = max(0, num_changelings - 1)
*/
	for(var/j = 0, j < num_xenomorphs, j++)
		var/datum/mind/xenomorph = pick(possible_xenomorphs)
		src.traitors += xenomorph
		possible_xenomorphs.Remove(xenomorph)
	boutput(world, "Oh fuck gets to cp two")
	for(var/datum/mind/xenomorph in src.traitors)
		if(!xenomorph || !istype(xenomorph))
			src.traitors.Remove(xenomorph)
			continue

		if(istype(xenomorph))
			xenomorph.special_role = "xenomorph"
	boutput(world, "Oh fuck gets to cp three")
	for (var/datum/mind/xenomorph in src.traitors)
		if (xenomorph.current)
			xenomorph.current.becoming_xenomorph = 1
			xenomorph.current.becoming_backup_xenomorph_queen = 1//fttb due to expected lowpop aliens,
			//this will guarantee a queen(in theory)
	boutput(world, "Oh fuck gets to cp four")
	var/found_queen = 0
	for (var/datum/mind/xenomorph in src.traitors)

		if (xenomorph.current && xenomorph.current.client.preferences.be_xenomorph_queen || xenomorph.current && xenomorph.current.fake_client_be_antag)
			if (!found_queen)
				xenomorph.current.becoming_xenomorph_queen = 1
				found_queen = 1
			else
				xenomorph.current.becoming_backup_xenomorph_queen = 1
	boutput(world, "Oh fuck gets to cp five")
	return 1

/datum/game_mode/xenomorph/post_setup()
	for(var/datum/mind/xenomorph in src.traitors)
		if(istype(xenomorph))
			xenomorph.current.make_true_xenomorph(xenomorph.current.becoming_xenomorph_queen)
		//	bestow_objective(changeling,/datum/objective/specialist/absorb)
		//	bestow_objective(changeling,/datum/objective/escape)

			//HRRFM horror form stuff goes here
		//	boutput(changeling.current, "<B><span style=\"color:red\">You feel... HUNGRY!</span></B><br>")

			// Moved antag help pop-up to changeling.dm (Convair880).

		//	var/obj_count = 1
	//		for(var/datum/objective/objective in changeling.objectives)
		//		boutput(changeling.current, "<B>Objective #[obj_count]</B>: [objective.explanation_text]")
		//		obj_count++

//	spawn (rand(waittime_l, waittime_h))
	//	send_intercept()

/datum/game_mode/xenomorph/proc/get_possible_xenomorphs(num_xenomorphs=1)
	var/list/candidates = list()

	for(var/mob/new_player/player in mobs)
		if (ishellbanned(player)) continue //No treason for you
		if ((player.client || player.fake_client) && (player.ready) && !(player.mind in traitors) && !(player.mind in token_players) && !candidates.Find(player.mind))
			if(player.client.preferences.be_xenomorph || player.fake_client_be_antag)
				candidates += player.mind

	if(candidates.len < num_xenomorphs)
		logTheThing("debug", null, null, "<b>Enemy Assignment</b>: Only [candidates.len] players with be_xenomorph set to yes were ready. We need [num_xenomorphs], so including players who don't want to be xenomorphs in the pool.")
		for(var/mob/new_player/player in mobs)
			if (ishellbanned(player)) continue //No treason for you
			if ((player.client || player.fake_client) && (player.ready) && !(player.mind in traitors) && !(player.mind in token_players) && !candidates.Find(player.mind))
				candidates += player.mind

	if(candidates.len < 1)
		return list()
	else
		return candidates

/datum/game_mode/xenomorph/proc/get_mob_list()
	var/list/mobs = list()
	for(var/mob/living/carbon/player in mobs)
		if (player.fake_client || player.client)
			mobs += player
	return mobs


/datum/game_mode/xenomorph/announce()
	boutput(world, "<B>The current game mode is - Alien Infestation!</B>")
	boutput(world, "<B>There is one or more <span style=\"color:red\">ALIEN ORGANISMS</span> on the station. Be on your guard!</B>")

/datum/game_mode/xenomorph/proc/set_end_time()
	game_ends_at_realtime = rand(72000, 108000)

/datum/game_mode/xenomorph/check_finished(var/time = 0)

	var/list/clients_on[0]
	var/list/mobs_alive[0]

	for (var/mob/m in mobs)
		if (m.stat != 1 && m.stat != 2 && !m.mind.is_xenomorph)
			mobs_alive.Add(m)

	for (var/client/c in clients)
		clients_on.Add(c)

	if (time > game_ends_at_realtime)
		return 1

	if (!mobs_alive.len)
		return 1

	if (clients_on.len)
		return 1

	return 0
