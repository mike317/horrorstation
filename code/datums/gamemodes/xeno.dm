#define BYPASSFAILEDSTART 0

/datum/game_mode/xeno
	name = "Alien Infestation"
	config_tag = "xeno"
	shuttle_available = 2

	late_crew_join = 1

	var/players_at_start = 0
	var/const/xenos_minimum = 1
	var/const/xenos_possible = 5
	var/const/waittime_l = 600 //lower bound on time before intercept arrives (in tenths of seconds)
	var/const/waittime_h = 1800 //upper bound on time before intercept arrives (in tenths of seconds)
	var/finish_counter = 0

	var/was_alien_sentinel = 0
	var/was_alien_warrior = 0
	var/was_alien_praetorian = 0
	var/was_alien_queen = 0

	var/roundstart_aliens = 0

	var/handled_warehouse_culling = 0

/datum/game_mode/xeno

	proc/isSentinel()
		for (var/mob/living/carbon/human/H in mobs)
			if (isAlienSentinel(H))
				return 1
		return 0
	proc/isWarrior()
		for (var/mob/living/carbon/human/H in mobs)
			if (isAlienWarrior(H))
				return 1
		return 0
	proc/isPraetorian()
		for (var/mob/living/carbon/human/H in mobs)
			if (isAlienPraetorian(H))
				return 1
		return 0
	proc/isQueen()
		for (var/mob/living/carbon/human/H in mobs)
			if (isAlienPraetorian(H))
				return 1
		return 0

	proc/alive_survivors()
		var/count = 0
		for (var/mob/living/carbon/human/H in mobs)
			if (H.stat != 2)
				if (H.mind)
					if (H.client)
						if (!isAlien(H))
							if (!Agimmicks.Find(H))
								count++

		return count

/datum/game_mode/xeno/announce()
	boutput(world, "<B>The current game mode is - <font color='red'>Alien Infestation</font>!</B>")
	boutput(world, "<B>There is one or more highly dangerous Xenomorphs on the station. At least one survivor must survive the infestation for a whole two hours in order to have a human victory.</B>")
	if (!late_crew_join)
		boutput(world, "<br><br><B>Late joining is not allowed.</B>")
/datum/game_mode/xeno/pre_setup()
	..()
	var/num_players = 0
	for(var/mob/new_player/player in mobs)
		if(player.client && player.ready) num_players++

	players_at_start = num_players

	if (players_at_start >= 15)
		late_crew_join = 0
	//var/i = rand(-10, 0)

	var/absolute_max_xenos = xenos_possible

	if (absolute_max_xenos > round(num_players/2))
		absolute_max_xenos = round(num_players/2)

	var/num_xenos = max(2, min(round(num_players / 10), absolute_max_xenos))

	if (num_xenos > round(num_players/2))
		num_xenos = round(num_players/2)

	if (num_xenos < 1)
		num_xenos = 1

	var/list/possible_xenos = get_possible_xenos(num_xenos)

	if (!possible_xenos || !islist(possible_xenos) || !possible_xenos.len || possible_xenos.len < xenos_minimum)
		if (!BYPASSFAILEDSTART)
			boutput(world, "<B>Not enough people had Alien toggled to continue.</B>")
			return 0


	for(var/j = 0, j < possible_xenos.len, j++)
		var/datum/mind/xeno = pick(possible_xenos)
		traitors += xeno
		possible_xenos.Remove(xeno)

	shuffle(traitors)//because we make, in ideal conditions, the first traitor queen
	//and the second traitor Warrior, we need some protection from abusing this

	var/iterations = 0
	var/queen = 0

	for(var/datum/mind/xeno in traitors)
		if(!xeno || !istype(xeno))
			traitors.Remove(xeno)
			continue
		if(istype(xeno))
			xeno.special_role = "xeno"
			roundstart_aliens++

			if (!iterations)
				if (xeno.current.client.preferences.be_xenomorph_queen == 1)
					xeno.assigned_role = "MODEPRIORITYONE"//you're forced queen if
					//your setting is toggled
					queen = 1

				else if (xeno.current.client.preferences.be_xenomorph_queen == 0)
					if (traitors.len == 1)
						xeno.assigned_role = "MODEPRIORITYONE"//you're still forced
						//queen if there's noone else
						queen = 1
					else
						xeno.assigned_role = "MODE"

			else if (iterations == 1)//todo: add a separate setting for el huntre

				if (xeno.current.client.preferences.be_xenomorph_queen == 0)
					if (queen)
						xeno.assigned_role = "MODEPRIORITYTWO"//you're forced warrior
					else
						if (iterations+1 == traitors.len)
							xeno.assigned_role = "MODEPRIORITYONE"

							queen = 1
						else
							xeno.assigned_role = "MODEPRIORITYTWO"


				else if (xeno.current.client.preferences.be_xenomorph_queen == 1)
					if (!queen)
						xeno.assigned_role = "MODEPRIORITYONE"//you're queen if
						//your setting is toggled

						queen = 1
					else
						xeno.assigned_role = "MODEPRIORITYTWO"


			else if (iterations > 1)
				if (xeno.current.client.preferences.be_xenomorph_queen == 0)
					if (queen)
						xeno.assigned_role = "MODE"

					else
						if (iterations+1 == traitors.len)//you're the last alien
							xeno.assigned_role = "MODEPRIORITYONE"

							queen = 1
						else
							xeno.assigned_role = "MODE"


				else if (xeno.current.client.preferences.be_xenomorph_queen == 1)
					if (!queen)
						xeno.assigned_role = "MODEPRIORITYONE"//you're forced queen if
						//your setting is toggled

						queen = 1
					else
						xeno.assigned_role = "MODE"



		iterations++


	return 1

/datum/game_mode/xeno/post_setup()
//	..()
	emergency_shuttle.disabled = 1

//	spawn (rand(waittime_l, waittime_h))
	//	send_intercept()



/datum/game_mode/xeno/send_intercept()
	var/intercepttext = "Cent. Com. Update Requested status information:<BR>"
	intercepttext += " Cent. Com has recently been contacted by the following syndicate affiliated organisations in your area, please investigate any information you may have:"

	var/list/possible_modes = list()
	possible_modes.Add("revolution", "wizard", "nuke", "traitor", "changeling")
	possible_modes -= "[ticker.mode]"
	var/number = pick(2, 3)
	var/i = 0
	for(i = 0, i < number, i++)
		possible_modes.Remove(pick(possible_modes))
	possible_modes.Insert(rand(possible_modes.len), "[ticker.mode]")

	var/datum/intercept_text/i_text = new /datum/intercept_text
	for(var/A in possible_modes)
		intercepttext += i_text.build(A, pick(ticker.minds))

	for (var/obj/machinery/communications_dish/C in machines)
		C.add_centcom_report("Cent. Com. Status Summary", intercepttext)

	command_alert("Summary downloaded and printed out at all communications consoles.", "Enemy communication intercept. Security Level Elevated.")

/datum/game_mode/xeno/check_win()
	if (check_finished())
		return 1
	else
		return 0

/datum/game_mode/xeno/proc/is_basically_dead(var/mob/m)
	if (istype(m, /mob/dead))
		return 1
	if (!m.loc.loc)
		return 1
	if (!m.client)
		return 1
	if (!m.key)
		return 1
	if (!m.mind)
		//probably another ghost check here
		return 1
	if (m.stat == 2)
		return 1
	if (m.loc.loc.name == "" || m.loc.loc.name == "area" || m.loc.loc.name == "Area" || istype(m.loc.loc, /area/listeningpost) || istype(m.loc.loc, /area/syndicate_teleporter) || istype(m.loc.loc, /area/wizard_station) || m.z > 1)
		return 1
	if (istype(m.loc, /obj))
		return 1

/datum/game_mode/xeno/check_finished()
	if (..())
		return 1

	if (clients.len == 0)//no clients on? finished
		return 1

	if (ticker.round_elapsed_ticks > 72000)//has the round lasted more than 2 hours? done.
		return 1

	var/real_clients = 0

	for (var/client/c in clients)
		if (c.mob.mind && c.mob.key)
			real_clients++

	if (real_clients == 0)
		return 1

	if (players_at_start >= 15)//was this "highpop"?
		if (clients.len == 1)//One client on?
			for (var/client/c in clients)
				if (c.mob.mind.special_role == "truexeno" || c.mob.mind.special_role == "xeno")
					return 1//is that one client an xeno or becoming an xeno? return.

	var/moblen = 0
	var/alienlen = 0

	for (var/mob/M in mobs)
		if (!is_basically_dead(M))
			if (M.client && M.mind)
				moblen++
				if (isAlien(M) && !isAlienHugger(M))
					alienlen++

	alienlen += aghosted_xenos.len

	if (players_at_start >= 15)
		if (moblen == alienlen && ticker.round_elapsed_ticks > 18000)//all players are aliens? Done
			return 1
	else
		if (moblen == alienlen && ticker.round_elapsed_ticks > 18000)//all players are aliens, same as other
		//check rn
			return 1

	if (alienlen == 0 && ticker.round_elapsed_ticks > 18000)//no aliens and longer than 30
	//min round
		return 1

	var/alive_survivors = 0//this seems like a redundant name but oh well

	for (var/mob/M in mobs)
		if (!isAlien(M) && M.mind.special_role != "truexeno" && M.mind.special_role != "xeno" && !findtext(M.mind.assigned_role, "MODE") && !traitors.Find(M))
			if (!is_basically_dead(M))
				alive_survivors++

	alive_survivors += aghosted_humans.len

	if (players_at_start >= 15)
		if (alive_survivors <= 0)//return if there are no survivors alive
			return 1
	else
		if (alive_survivors <= 0 && ticker.round_elapsed_ticks > 18000)
			//return if there are no survivors and survivors have had 30 mins to join
			return 1

		/*
	for (var/datum/mind/M in traitors)//search through traitors list
		if (M.current && isAlien(M.current) && M.current.stat != 2)//any aliens alive? We know there is more than 1 client at this point
			return 0//do not end!							//and that there is at least 2 more survivor
	//if all aliens are dead
		*/
	return 0

/datum/game_mode/xeno/declare_completion()
	var/list/xenos = list()

	for (var/datum/mind/M in traitors)
		if (!M)
			continue
		if (isAlien(M.current) && !isAlienHugger(M.current))
			xenos += M.current

	for (var/datum/mind/M in Agimmicks)
		if (!M)
			continue
		xenos += M.current

	if (!xenos.len)
		boutput(world, "<span style='font-size:20px; color:red'><b>Survivor victory!</b> - All Xenomorphs have been exterminated!")
	else
		boutput(world, "<span style='font-size:20px; color:red'><b>Alien victory!</b> - The crew failed to survive the round.")

//	..()

/datum/game_mode/xeno/proc/get_possible_xenos(num_xenos=1)
	var/list/candidates = list()

	for(var/mob/new_player/player in mobs)
		if (ishellbanned(player)) continue //No treason for you
		if ((player.client) && (player.ready) && !(player.mind in traitors) && !(player.mind in token_players) && !candidates.Find(player.mind))
			if(player.client.preferences.be_xenomorph)
				candidates += player.mind
/*
	if(candidates.len < num_xenos)
		logTheThing("debug", null, null, "<b>Enemy Assignment</b>: Only [candidates.len] players with be_xeno set to yes were ready. We need [num_xenos], so including players who don't want to be xeno start in the pool.")
		for(var/mob/new_player/player in mobs)
			if (ishellbanned(player)) continue //No treason for you
			if ((player.client) && (player.ready) && !(player.mind in traitors) && !(player.mind in token_players) && !candidates.Find(player.mind))
				candidates += player.mind
*/
	if(candidates.len < 1)
		return list()
	else
		return candidates
