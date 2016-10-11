/proc/SetupOccupationsList()
	set background = 1

	var/list/new_occupations = list()

	for(var/occupation in occupations)
		if (!(new_occupations.Find(occupation)))
			new_occupations[occupation] = 1
		else
			new_occupations[occupation] += 1
	occupations = new_occupations
	return

/proc/FindOccupationCandidates(list/unassigned, job, level)
	set background = 1

	var/list/candidates = list()

	for (var/mob/new_player/player in unassigned)

		var/datum/job/J = find_job_in_controller_by_string(job)
		if(checktraitor(player))
			if ((ticker && ticker.mode && istype(ticker.mode, /datum/game_mode/revolution)) && J.cant_spawn_as_rev)
				// Fixed AI, security etc spawning as rev heads. The special job picker doesn't care about that var yet,
				// but I'm not gonna waste too much time tending to a basically abandoned game mode (Convair880).
				continue
			else if((ticker && ticker.mode && istype(ticker.mode, /datum/game_mode/gang)) && (job != "Staff Assistant"))
				continue
		if (!J.allow_traitors && player.mind.special_role)
			continue
		if (J.requires_whitelist && !NT.Find(ckey(player.mind.key)))
			continue
		if (jobban_isbanned(player, job) || job in player.client.preferences.jobs_unwanted)
			continue
		if (level == 1 && player.client.preferences.job_favorite == job)
			candidates += player
		else if (level == 2 && job in player.client.preferences.jobs_med_priority)
			candidates += player
		else if (level == 3 && job in player.client.preferences.jobs_low_priority)
			candidates += player

	return candidates

/proc/PickOccupationCandidate(list/candidates)
	if (candidates.len > 0)
//		var/list/randomcandidates = shuffle(candidates) //Is there really any need to use shuffle() when it just uses pick internally anyway, and you throw away all but one result?
//		candidates -= randomcandidates[1]
//		return randomcandidates[1]
		return pick(candidates)

//
	return null

/proc/DivideOccupations()
	set background = 1

	var/list/unassigned = list()

	for (var/mob/new_player/player in mobs)
		if (player.client && player.ready && !player.mind.assigned_role)
			unassigned += player

	if (unassigned.len == 0)
		return 0

	// If the mode is construction, ignore all this shit and sort everyone into the construction worker job.
	if (master_mode == "construction")
		for (var/mob/new_player/player in unassigned)
			player.mind.assigned_role = "Construction Worker"
		return

	var/list/pick1 = list()
	var/list/pick2 = list()
	var/list/pick3 = list()

	// Stick all the available jobs into its own list so we can wiggle the fuck outta it
	var/list/available_job_roles = list()
	// Apart from ones in THIS list, which are jobs we want to assign before any others
	var/list/high_priority_jobs = list()
	// This list is for jobs like staff assistant which have no limits, or other special-case
	// shit to hand out to people who didn't get one of the main limited slot jobs
	var/list/low_priority_jobs = list()

	for(var/datum/job/JOB in job_controls.staple_jobs)
		// If it's hi-pri, add it to that list. Simple enough
		if (JOB.high_priority_job)
			high_priority_jobs.Add(JOB)
		// If we've got a job with the low priority var set or no limit, chuck it in the
		// low-pri list and move onto the next job - if we don't do this, the first time
		// it hits a limitless job it'll get stuck on it and hand it out to everyone then
		// boot the game up resulting in ~WEIRD SHIT~
		else if (JOB.low_priority_job || JOB.limit < 0)
			low_priority_jobs += JOB.name
			continue
		// otherwise it's a normal role so it goes in that list instead
		else
			available_job_roles.Add(JOB)

	// Wiggle it like a pissy caterpillar
	available_job_roles = shuffle(available_job_roles)
	// Wiggle the players too so that priority isn't determined by key alphabetization
	unassigned = shuffle(unassigned)

	// First we deal with high-priority jobs like Captain or AI which generally will always
	// be present on the station - we want these assigned first just to be sure
	// Though we don't want to do this in sandbox mode where it won't matter anyway
	if(master_mode != "sandbox")
		for(var/datum/job/JOB in high_priority_jobs)
			if (unassigned.len == 0) break

			if (JOB.limit > 0 && JOB.assigned >= JOB.limit) continue

			// get all possible candidates for it
			pick1 = FindOccupationCandidates(unassigned,JOB.name,1)
			pick2 = FindOccupationCandidates(unassigned,JOB.name,2)
			pick3 = FindOccupationCandidates(unassigned,JOB.name,3)

			// now assign them - i'm not hardcoding limits on these because i don't think any
			// of us are quite stupid enough to edit the AI's limit to -1 preround and have a
			// horrible multicore PC station round.. (i HOPE anyway)
			for(var/mob/new_player/candidate in pick1)
				if (JOB.assigned >= JOB.limit || unassigned.len == 0) break
				logTheThing("debug", null, null, "<b>I Said No/Jobs:</b> [candidate] took [JOB.name] from High Priority Job Picker Lv1")
				candidate.mind.assigned_role = JOB.name
				logTheThing("debug", candidate, null, "assigned job: [candidate.mind.assigned_role]")
				unassigned -= candidate
				JOB.assigned++
			for(var/mob/new_player/candidate in pick2)
				if (JOB.assigned >= JOB.limit || unassigned.len == 0) break
				logTheThing("debug", null, null, "<b>I Said No/Jobs:</b> [candidate] took [JOB.name] from High Priority Job Picker Lv2")
				candidate.mind.assigned_role = JOB.name
				logTheThing("debug", candidate, null, "assigned job: [candidate.mind.assigned_role]")
				unassigned -= candidate
				JOB.assigned++
			for(var/mob/new_player/candidate in pick3)
				if (JOB.assigned >= JOB.limit || unassigned.len == 0) break
				logTheThing("debug", null, null, "<b>I Said No/Jobs:</b> [candidate] took [JOB.name] from High Priority Job Picker Lv3")
				candidate.mind.assigned_role = JOB.name
				logTheThing("debug", candidate, null, "assigned job: [candidate.mind.assigned_role]")
				unassigned -= candidate
				JOB.assigned++
	else
		// if we are in sandbox mode just roll the hi-pri jobs back into the regular list so
		// people can still get them if they chose them
		available_job_roles = available_job_roles | high_priority_jobs

	// Next we go through each player and see if we can get them into their favorite jobs
	// If we don't do this loop then the main loop below might get to a job they have in their
	// medium or low priority lists first and give them that one rather than their favorite
	for (var/mob/new_player/player in unassigned)
		// If they don't have a favorite, skip em
		if (derelict_mode) // stop freaking out at the weird jobs
			continue
		if (!player.client.preferences || player.client.preferences.job_favorite == null)
			continue
		// Now get the in-system job via the string
		var/datum/job/JOB
		JOB = find_job_in_controller_by_string(player.client.preferences.job_favorite)

		// Do a few checks to make sure they're allowed to have this job
		if (ticker && ticker.mode && istype(ticker.mode, /datum/game_mode/revolution))
			if(checktraitor(player) && JOB.cant_spawn_as_rev)
				// Fixed AI, security etc spawning as rev heads. The special job picker doesn't care about that var yet,
				// but I'm not gonna waste too much time tending to a basically abandoned game mode (Convair880).
				continue
		if (!JOB || jobban_isbanned(player,JOB.name))
			continue
		if (JOB.requires_whitelist && !NT.Find(ckey(player.mind.key)))
			continue
		if (!JOB.allow_traitors && player.mind.special_role)
			continue
		// If there's an open job slot for it, give the player the job and remove them from
		// the list of unassigned players, hey presto everyone's happy (except clarks probly)
		if (JOB.limit < 0 || !(JOB.assigned >= JOB.limit))
			logTheThing("debug", null, null, "<b>I Said No/Jobs:</b> [player] took [JOB.name] from favorite selector")
			player.mind.assigned_role = JOB.name
			logTheThing("debug", player, null, "assigned job: [player.mind.assigned_role]")
			unassigned -= player
			JOB.assigned++

	// Do this loop twice - once for med priority and once for low priority, because elsewise
	// it was causing weird shit to happen where having something in low priority would
	// sometimes cause you to get that instead of a higher prioritized job
	for(var/datum/job/JOB in available_job_roles)
		// If we've got everyone a job, then stop wasting cycles and get on with the show
		if (unassigned.len == 0) break
		// If there's no more slots for this job available, move onto the next one
		if (JOB.limit > 0 && JOB.assigned >= JOB.limit) continue
		// First, rebuild the lists of who wants to be this job
		pick2 = FindOccupationCandidates(unassigned,JOB.name,2)
		// Now loop through the candidates in order of priority, and elect them to the
		// job position if possible - if at any point the job is filled, break the loops
		for(var/mob/new_player/candidate in pick2)
			if (JOB.assigned >= JOB.limit || unassigned.len == 0)
				break
			logTheThing("debug", null, null, "<b>I Said No/Jobs:</b> [candidate] took [JOB.name] from Level 2 Job Picker")
			candidate.mind.assigned_role = JOB.name
			logTheThing("debug", candidate, null, "assigned job: [candidate.mind.assigned_role]")
			unassigned -= candidate
			JOB.assigned++

	// And then again for low priority
	for(var/datum/job/JOB in available_job_roles)
		if (unassigned.len == 0)
			break

		if (JOB.limit == 0)
			continue

		if (JOB.limit > 0 && JOB.assigned >= JOB.limit)
			continue

		pick3 = FindOccupationCandidates(unassigned,JOB.name,3)
		for(var/mob/new_player/candidate in pick3)
			if (JOB.assigned >= JOB.limit || unassigned.len == 0) break
			logTheThing("debug", null, null, "<b>I Said No/Jobs:</b> [candidate] took [JOB.name] from Level 3 Job Picker")
			candidate.mind.assigned_role = JOB.name
			logTheThing("debug", candidate, null, "assigned job: [candidate.mind.assigned_role]")
			unassigned -= candidate
			JOB.assigned++

/* commenting this out because it's causing people to randomly become monkeys and shit and I guess it was set up before special jobs were enabled on default
	// If there are any special jobs that have been made available pre-round, sort any
	// remaining players into them
	if (job_controls.allow_special_jobs)
		for(var/datum/job/JOB in job_controls.special_jobs)
			if (unassigned.len == 0)
				break
			if (JOB.limit == 0)
				continue
			if (JOB.limit > 0 && JOB.assigned >= JOB.limit)
				continue
			var/mob/new_player/candidate = pick(unassigned)
			logTheThing("debug", null, null, "<b>I Said No/Jobs:</b> [candidate] took [JOB.name] from special job picker")
			candidate.mind.assigned_role = JOB.name
			logTheThing("debug", candidate, null, "assigned job: [candidate.mind.assigned_role]")
			unassigned -= candidate
			JOB.assigned++
*/
	// If there's anyone left without a job after this, lump them with a randomly
	// picked low priority role and be done with it
	if (!low_priority_jobs.len)
		// we really need to fix this or it'll be some kinda weird inf loop shit
		if (ALIENMODE == 0)
			low_priority_jobs += "Staff Assistant"


	//	else
		//	low_priority_jobs += "Survivor"


	for (var/mob/new_player/player in unassigned)
		logTheThing("debug", null, null, "<b>I Said No/Jobs:</b> [player] given a low priority role")
		player.mind.assigned_role = pick(low_priority_jobs)
		logTheThing("debug", player, null, "assigned job: [player.mind.assigned_role]")

	return 1

/mob/living/carbon/human/proc/Equip_Rank(rank, joined_late)

	var/datum/job/JOB = find_job_in_controller_by_string(rank)
	if (!JOB)
		return

	//if(JOB.name == "Captain")
		//boutput(world, "<b>[src] is the Captain!</b>")
	if (JOB.announce_on_join && !ALIENMODE)
		boutput(world, "<b>[src] is the [JOB.name]!</b>")

	boutput(src, "<B>You are the [JOB.name].</B>")
	src.job = JOB.name
	src.mind.assigned_role = JOB.name



	if (!joined_late)
		if ((ticker && ticker.mode && !istype(ticker.mode, /datum/game_mode/construction) && !istype(ticker.mode, /datum/game_mode/xeno)) && JOB.name != "Tourist")
			var/obj/S = null
			if (job_start_locations && islist(job_start_locations[JOB.name]))
				var/list/locations = job_start_locations[JOB.name]
				S = pick(locations)
				if (locate(/mob) in S.loc)
					for (var/i=5, i>0, i--)
						S = pick(locations)
						if (!(locate(/mob) in S.loc))
							break
			else
				for (var/obj/landmark/start/sloc in world)
					if (sloc.name != JOB.name)
						continue
					if (locate(/mob) in sloc.loc)
						continue
					S = sloc
					break
			if (!S)
				S = locate("start*[JOB.name]") // use old stype
			if (istype(S, /obj/landmark/start) && isturf(S.loc))
				src.set_loc(S.loc)
		else
			if (istype(ticker.mode, /datum/game_mode/construction))
				src.set_loc(pick(latejoin))

			else if (istype(ticker.mode, /datum/game_mode/xeno))

				src.warehouse_spawn()
	else
		src.unlock_medal("Fish", 1)

		if (ALIENMODE)
			src.warehouse_spawn()


	if (time2text(world.realtime, "MM DD") == "12 25")
		src.unlock_medal("A Holly Jolly Spacemas")

	if (JOB.slot_back)
		src.equip_if_possible(new JOB.slot_back(src), slot_back)
		if (JOB.items_in_backpack.len && istype(src.back, /obj/item/storage))
			for (var/X in JOB.items_in_backpack)
				if (ALIENMODE && !istype(X, /obj/item/crowbar))

					src.equip_if_possible(new X(src), slot_in_backpack)
				else
					src.equip_if_possible(new/obj/item/crowbar/survivor_crowbar, slot_in_backpack)

	if (JOB.slot_jump)
		src.equip_if_possible(new JOB.slot_jump(src), slot_w_uniform)

	if (JOB.slot_belt)
		if (src.bioHolder && src.bioHolder.HasEffect("fat"))
			src.equip_if_possible(new JOB.slot_belt(src), slot_in_backpack)
		else
			src.equip_if_possible(new JOB.slot_belt(src), slot_belt)
			if (src.traitHolder && src.traitHolder.hasTrait("immigrant") && istype(src.belt, /obj/item/device/pda2))
				del(src.belt) //UGHUGHUGHUGUUUUUUUU
		if (JOB.items_in_belt.len && istype(src.belt, /obj/item/storage))
			for (var/X in JOB.items_in_belt)
				src.equip_if_possible(new X(src), slot_in_belt)

	if (JOB.slot_foot)
		src.equip_if_possible(new JOB.slot_foot(src), slot_shoes)
	if (JOB.slot_suit)
		src.equip_if_possible(new JOB.slot_suit(src), slot_wear_suit)
	if (JOB.slot_ears)
		src.equip_if_possible(new JOB.slot_ears(src), slot_ears)
	if (JOB.slot_mask)
		src.equip_if_possible(new JOB.slot_mask(src), slot_wear_mask)
	if (JOB.slot_glov)
		src.equip_if_possible(new JOB.slot_glov(src), slot_gloves)
	if (JOB.slot_eyes)
		src.equip_if_possible(new JOB.slot_eyes(src), slot_glasses)
	if (JOB.slot_head)
		src.equip_if_possible(new JOB.slot_head(src), slot_head)
	if (JOB.slot_poc1)
		if (src.bioHolder && src.bioHolder.HasEffect("fat"))
			src.equip_if_possible(new JOB.slot_poc1(src), slot_in_backpack)
		else
			src.equip_if_possible(new JOB.slot_poc1(src), slot_l_store)
	if (JOB.slot_poc2)
		if (src.bioHolder && src.bioHolder.HasEffect("fat"))
			src.equip_if_possible(new JOB.slot_poc2(src), slot_in_backpack)
		else
			src.equip_if_possible(new JOB.slot_poc2(src), slot_r_store)
	if (JOB.slot_rhan)
		src.equip_if_possible(new JOB.slot_rhan(src), slot_r_hand)
	if (JOB.slot_lhan)
		src.equip_if_possible(new JOB.slot_lhan(src), slot_l_hand)

	var/T = pick(trinket_safelist)
	var/obj/item/trinket = null

	if (src.traitHolder && src.traitHolder.hasTrait("loyalist"))
		trinket = new/obj/item/clothing/head/NTberet(src)
	else if (src.traitHolder && src.traitHolder.hasTrait("petasusaphilic"))
		var/picked = pick(typesof(/obj/item/clothing/head) - list(/obj/item/clothing/head, /obj/item/clothing/head/power, /obj/item/clothing/head/fancy, /obj/item/clothing/head/monkey, /obj/item/clothing/head/monkey/paper_hat) ) //IM A MONSTER DONT LOOK AT ME. NOOOOOOOOOOO
		trinket = new picked(src)
	else
		trinket = new T(src)

	if (trinket) // rewrote this a little bit so hopefully people will always get their trinket
		trinket.name = "[src.real_name][pick(trinket_names)] [trinket.name]"
		trinket.quality = rand(5,80)
		var/equipped = 0
		if (istype(src.back, /obj/item/storage) && src.equip_if_possible(trinket, slot_in_backpack))
			equipped = 1
		else if (istype(src.belt, /obj/item/storage) && src.equip_if_possible(trinket, slot_in_belt))
			equipped = 1
		if (!equipped)
			if (!src.l_store && src.equip_if_possible(trinket, slot_l_store))
				equipped = 1
			else if (!src.r_store && src.equip_if_possible(trinket, slot_r_store))
				equipped = 1
			else if (!src.l_hand && src.equip_if_possible(trinket, slot_l_hand))
				equipped = 1
			else if (!src.r_hand && src.equip_if_possible(trinket, slot_r_hand))
				equipped = 1

			if (!equipped) // we've tried most available storage solutions here now so uh just put it on the ground
				trinket.set_loc(get_turf(src))

	JOB.special_setup(src)

	// Manifest stuff
	data_core.addManifest(src)

	spawn(0)
		if (src.traitHolder && !src.traitHolder.hasTrait("immigrant"))
			spawnId(rank)

		if (prob(10) && islist(random_pod_codes) && random_pod_codes.len)
			var/obj/machinery/vehicle/V = pick(random_pod_codes)
			random_pod_codes -= V
			if (V && V.lock && V.lock.code)
				boutput(src, "<span style=\"color:blue\">The unlock code to your pod ([V]) is: [V.lock.code]</span>")
				if (src.mind)
					src.mind.store_memory("The unlock code to your pod ([V]) is: [V.lock.code]")

		if (src.mind && src.mind.late_special_role == 1 && src.mind.special_role == "traitor")
			//put this here because otherwise it's called before they have a PDA
			equip_traitor(src)

		set_clothing_icon_dirty()
		sleep(1)
		update_icons_if_needed()

	return


/mob/living/carbon/human/proc/warehouse_spawn()

	var/initial_spawn = 0

	if (istype(ticker.mode, /datum/game_mode/xeno) && !ticker.mode:handled_warehouse_culling)

		var/playercount = 0

//		for(var/mob/new_player/player in mobs)
	//		if(player.client && player.ready) playercount++

		for (var/mob/living/carbon/human/human in mobs)
			if (human.client && human.stat != 2)
				if (!isAlien(human))
					playercount++

		var/max_warehouses = 1
		if (playercount > 8)
			max_warehouses = 2
		else if (playercount > 16)
			max_warehouses = 3
		else if (playercount > 24)
			max_warehouses = 4

		while (random_survivor_start.len < survivor_start.len)//I think there is a random list proc but fuck it - Cherkir
			random_survivor_start += pick(survivor_start)

		random_survivor_start.len = max_warehouses

		ticker.mode:handled_warehouse_culling = 1

		initial_spawn = 1
//	for (var/mob/m in readied_players or something)
//
//	if (mobcount < 10)
//		survivors_start.cull
	var/start = pick(random_survivor_start)
	/*

	var/woodspawn1 = locate(src.x+3, src.y+2, src.z)
	var/woodspawn2 = locate(src.x+3, src.y-2, src.z)
	var/woodspawn3 = locate(src.x+2, src.y+3, src.z)
	var/woodspawn4 = locate(src.x+2, src.y-3, src.z)

	if (prob(75))
		new/obj/decal/woodclutter(woodspawn1)
	if (prob(75))
		new/obj/decal/woodclutter(woodspawn2)
	if (prob(75))
		new/obj/decal/woodclutter(woodspawn3)
	if (prob(75))
		new/obj/decal/woodclutter(woodspawn4)
	*/

	if (!locate(/obj/burning_barrel) in start)
		new/obj/burning_barrel(start)

	var/central_spawn_loc = locate(start:x+1, start:y, start:z)

	src.set_loc(start)

	src.set_loc(locate(src.x+rand(-1,1), src.y+rand(-1,1), src.z))

	var/tries = 0

	back

	var/mobcount = 0

	for (var/mob/m in src.loc)
		mobcount++

	if (mobcount > 1)
		src.set_loc(src.x+rand(-1,1), src.y+rand(-1,1), src.z)

	for (var/mob/m in src.loc)
		mobcount++

	if (mobcount > 1 && tries < 8)//rng means they still might spawn on someone once in a while, but oh well
		tries++
		goto back

	if (!istype(src.loc, /turf/simulated/floor))//shitty fix to the spawning in space bug
		src.loc = central_spawn_loc


	alien_mode_spawn_stuff(central_spawn_loc, initial_spawn)

proc/random_tenth_decimal(var/r1, var/r2)

	return (rand(r1 * 100, r2 * 100))/100

/mob/living/carbon/human/proc/alien_mode_spawn_stuff(var/group = 0, var/init_spawn = 0)
	if (isAlien(src))
		return 0//no get out ayys ree
	var/next_turf = null
	var/another_turf = (prob(30) ? 1 : null)
	var/welding_tank_or_barrel = 0//0 = tank, 1 = barrel
	var/turf/simulated/floor/available_turfs[0]

	var/spawn_time = 10

	if (init_spawn)
		sleep(50)

		var/max_v = rand(50, 60)//all things considered 20 to 30 wasn't much at all, you might have to block off 4+ or more
		//entrances from a bunch of hungry aliens and 5 to 7 pieces of wood to reinforce each entrance was tiny

		for (var/v = 1, v <= max_v, v++)
			if (prob(80))
				var/wherethewoodat = pick("clutter", "plank")
				if (wherethewoodat == "clutter")
					spawn (spawn_time * 1.5 * random_tenth_decimal(1,2))
						var/obj/o = new/obj/item/woodstuff/woodclutter(locate(next_turf:x+rand(-3,3), next_turf:y+rand(-3,3), next_turf:z))
						if (!istype(o.loc, /turf/simulated/floor))
							qdel(o)
				else
					spawn (spawn_time * 1.5 * random_tenth_decimal(1,2))
						var/obj/o = new/obj/item/woodstuff/plank(locate(next_turf:x+rand(-3,3), next_turf:y+rand(-3,3), next_turf:z))
						if (!istype(o.loc, /turf/simulated/floor))
							qdel(o)
		spawn (spawn_time * 2)
			var/obj/reagent_barrel/salt_barrel/saltb = new/obj/reagent_barrel/salt_barrel(locate(next_turf:x+rand(-2,2), next_turf:y+rand(-2,2), next_turf:z))
			var/obj/reagent_barrel/rum_barrel/rumb = new/obj/reagent_barrel/rum_barrel(locate(next_turf:x+rand(-2,2), next_turf:y+rand(-2,2), next_turf:y))

			if (rumb.loc == saltb.loc)//probably won't be a problem
				if (istype(locate(rumb.x+1, rumb.y, rumb.z), /turf/simulated/floor))
					rumb.x++
				else
					rumb.x--
/*
		for (var/v = 1, v <= 7, v++)
			if (prob(60))
				var/obj/reagent_barrel/salt_barrel/b = new/obj/reagent_barrel/salt_barrel(locate(next_turf:x+rand(-3,3), next_turf:y+rand(-3,3), next_turf:z))
				for (var/obj/item/i in b.loc)
					qdel(i)
			else
				var/obj/reagent_barrel/rum_barrel/b = new/obj/reagent_barrel/rum_barrel(locate(next_turf:x+rand(-3,3), next_turf:y+rand(-3,3), next_turf:z))
				for (var/obj/item/i in b.loc)
					qdel(i)
					*/

		for (var/v = 1, v <= 10, v++)
			if (prob(70))
				spawn (spawn_time * 2.5 * random_tenth_decimal(1,2))
					var/obj/item/device/glowstick/g = new/obj/item/device/glowstick(next_turf:x+rand(-3,3), next_turf:y+rand(-3,3), next_turf:z)
					g.on = 1
					g.icon_state = "glowstick-on"
					g.light.enable()

		for (var/v = 1, v <= 10, v++)
			if (prob(80))
				spawn (spawn_time * 3 * random_tenth_decimal(1,2))
					var/obj/item/reagent_containers/food/snacks/ingredient/meat/monkeymeat/goodmeat = new/obj/item/reagent_containers/food/snacks/ingredient/meat/monkeymeat(locate(next_turf:x+rand(-3,3), next_turf:y+rand(-3,3), next_turf:z))
					goodmeat.salt()

		for (var/v = 1, v <= 10, v++)
			if (prob(80))
				spawn (spawn_time * 5 * random_tenth_decimal(1,2))
					new/obj/item/reagent_containers/patch/synthflesh(locate(next_turf:x+rand(-3,3), next_turf:y+rand(-3,3), next_turf:z))
			if (prob(60))
				spawn (spawn_time * 5 * random_tenth_decimal(1,2))
					new/obj/item/reagent_containers/patch/mini/bruise(locate(next_turf:x+rand(-3,3), next_turf:y+rand(-3,3), next_turf:z))
			if (prob(40))
				spawn (spawn_time * 5 * random_tenth_decimal(1,2))
					new/obj/item/reagent_containers/patch/mini/burn(locate(next_turf:x+rand(-3,3), next_turf:y+rand(-3,3), next_turf:z))
			if (prob(10))
				spawn (spawn_time * 5 * random_tenth_decimal(1,2))
					new/obj/item/reagent_containers/patch/mini/omnipatch(locate(next_turf:x+rand(-3,3), next_turf:y+rand(-3,3), next_turf:z))
			if (prob(50))
				spawn (spawn_time * 5 * random_tenth_decimal(1,2))
					new/obj/item/reagent_containers/patch/mini/antifoodpoisoningpatch(locate(next_turf:x+rand(-3,3), next_turf:y+rand(-3,3), next_turf:z))
			if (prob(30))
				spawn (spawn_time * 5 * random_tenth_decimal(1,2))
					new/obj/item/reagent_containers/patch/mini/antitoxinpatch(locate(next_turf:x+rand(-3,3), next_turf:y+rand(-3,3), next_turf:z))

		spawn (spawn_time * 6)
			for (var/turf/t in range(3, next_turf))
				if (t.density)
					for (var/obj/item/i in t)
						qdel(i)
//	if (prob(75))//not everyone and their bee should spawn with a welding tank
	//	welding_tank_or_barrel = 1

	welding_tank_or_barrel = 1
	//next turf
	for (var/turf/simulated/floor/f in orange(1, src))
		var/cont_next = 0
		for (var/obj/o in f)
			if (!istype(o, /obj/overlay) && o.layer > f)
				cont_next = 1
				break

		if (!cont_next)
			if (istype(f))
				available_turfs += f
		else
			continue

	for (var/turf/simulated/floor/f in orange(1, src))
		if (prob(100/available_turfs.len))
			next_turf = f

	if (!next_turf)
		for (var/turf/simulated/floor/f in orange(1, src))
			next_turf = f
			break

	available_turfs.len = 0
	//end next turf
	for (var/turf/simulated/floor/f in orange(1, src))
		var/cont_next = 0
		for (var/obj/o in f)
			if (!istype(o, /obj/overlay) && o.layer > f)
				cont_next = 1
				break

		if (!cont_next)
			if (istype(f))
				available_turfs += f
		else
			continue

	if (another_turf)
		for (var/turf/simulated/floor/f in orange(1, src))
			if (prob(100/available_turfs.len))
				if (f != next_turf)
					another_turf = f

	var/tries_for_unique_turf = 0

	if (!another_turf)
		for (var/turf/simulated/floor/f in orange(1, src))
			another_turf = f
			if (another_turf == next_turf && tries_for_unique_turf <= 5)
				tries_for_unique_turf++
				continue
			else
				break//if we can't get a unique turf after 5 tries, fuck it all

	//you're more or less guaranteed to get something here. Different jobs
	//have different space availability, so we'll let them choose what they
	//take with them

	if (group && isturf(group))
		next_turf = group


	var/obj/item/crowbar/survivor_crowbar/c = new/obj/item/crowbar/survivor_crowbar(next_turf)//lets survivors get out of anywhere
	src.equip_if_possible(c, slot_r_hand)

	if (!locate(c) in src)
		src.equip_if_possible(c, slot_l_hand)

	spawn (spawn_time * random_tenth_decimal(1,2))
		new/obj/item/device/flashlight(next_turf)
	spawn (spawn_time * random_tenth_decimal(1,2))
		if (prob(30))
			new/obj/item/device/multitool(next_turf)
	spawn (spawn_time * random_tenth_decimal(1,2))
		if (prob(60))
			new/obj/item/wirecutters(next_turf)
	spawn (spawn_time * random_tenth_decimal(1,2))
		if (prob(40))
			new/obj/item/wrench(next_turf)
	spawn (spawn_time * random_tenth_decimal(1,2))
		if (prob(70))
			new/obj/item/screwdriver(next_turf)
	spawn (spawn_time * random_tenth_decimal(1,2))
		if (prob(50))
			new/obj/item/knife_butcher(next_turf)

		else
			new/obj/item/kitchen/utensil/knife(next_turf)

	//insulated gloves
	spawn (spawn_time * random_tenth_decimal(1,2))
		if (prob(20))
			var/obj/item/clothing/gloves/yellow/gloves = new/obj/item/clothing/gloves/yellow(next_turf)
			equip_if_possible(gloves, slot_gloves)

	//weapon spawn
	spawn (spawn_time * random_tenth_decimal(1,2))
		if (prob(17))
			new/obj/item/device/flash(next_turf)
	spawn (spawn_time * random_tenth_decimal(1,2))
		if (prob(15))
			new/obj/item/gun/energy/taser_gun(next_turf)
	spawn (spawn_time * random_tenth_decimal(1,2))
		if (prob(10))
			new/obj/item/gun/energy/laser_gun(next_turf)
	spawn (spawn_time * random_tenth_decimal(1,2))
		new/obj/item/cable_coil(next_turf)
	spawn (spawn_time * random_tenth_decimal(1,2))
		if (prob(50))
			new/obj/item/cable_coil(next_turf)
	spawn (spawn_time * random_tenth_decimal(1,2))
		new/obj/item/electronics/battery(next_turf)
	spawn (spawn_time * random_tenth_decimal(1,2))
		if (prob(50))
			new/obj/item/electronics/battery(next_turf)
//	new/obj/item/shaker/salt(next_turf)


	if (!group)
		if (another_turf && !welding_tank_or_barrel)
			new/obj/item/weldingtool(next_turf)
			if (prob(90))
				if (!locate(/obj/burning_barrel) in range(1, another_turf))
					new/obj/reagent_dispensers/fueltank(another_turf)

		else if (another_turf && welding_tank_or_barrel)
			if (!locate(/obj/reagent_dispensers/fueltank) in range(1, another_turf))
				new/obj/burning_barrel(another_turf)






	spawn (5)
		boutput(src, "<b>You've spawned with several vital tools, including a crowbar. Use this to open depowered doors.</b><br>")

		new/datum/objective_set/survivor(src.mind)

		var/obj_count = 1

		for (var/datum/objective/objective in src.mind.objectives)
			boutput(src, "<B>Objective #[obj_count]</B>: [objective.explanation_text]")
			obj_count++

		for (var/mob/living/carbon/human/ayy in world)
			if (isAlien(ayy))
				var/abs_dist = abs ( (ayy.x + ayy.y) - (src.x + src.y) )



				if (abs_dist < 50)//oh shit
					if (prob(80))
						boutput(src, "<br><br><span style = \"color:red\"><b>You know that you are very close to an Xenomorph.</span></b>")
						break
				else
					if (prob(30))
						boutput(src, "<br><br><span style = \"color:red\"><b>You know that there is an Xenomorph at [ayy.loc.loc].</span></b>")
						break

		for (var/obj/landmark/loot_spawn/l in world)

			if (prob(20))
				if (l.loc.loc)
					boutput(src, "<br><br><span style = \"color:red\"><b>You know that there are some [l.loot_first ? l.loot_first_name : ""]s[l.loot_second ? " and some [l.loot_second_name]s" : ""] at [l.loc.loc].</span></b>")

		for (var/mob/living/carbon/human/monkey/firstmonkey in world)//since xenostarts were already removed

			var/monkey_count = 1

			for (var/mob/living/carbon/human/monkey/m in range(10, firstmonkey))
				monkey_count++

			if (monkey_count >= 2)//there is roughly a 20% chance for each xeno start to have 2 monkeys
				var/m_area = "nowhere"
				if (istype(firstmonkey.loc, /obj))
					if (firstmonkey.loc.loc.loc)
						m_area = firstmonkey.loc.loc.loc
				else if (istype(firstmonkey.loc, /turf))
					if (firstmonkey.loc.loc)
						m_area = firstmonkey.loc.loc

				if (prob(50))
					boutput(src, "<br><br><span style = \"color:red\"><b>You know that a good place to gather food is [m_area], but beware of Xenomorphs.</span></b>")
					break//should prevent same location being output twice

/mob/living/carbon/human/proc/spawnId(rank)
	var/obj/item/card/id/C = null
	var/datum/job/JOB = find_job_in_controller_by_string(rank)
	if (!JOB || !JOB.slot_card)
		return null

	C = new JOB.slot_card(src)

	if(C)
		var/realName = src.real_name

		if(src.traitHolder && src.traitHolder.hasTrait("clericalerror"))
			realName = replacetext(realName, "a", "o")
			realName = replacetext(realName, "e", "i")
			realName = replacetext(realName, "u", pick("a", "e"))
			if(prob(50)) realName = replacetext(realName, "n", "m")
			if(prob(50)) realName = replacetext(realName, "t", pick("d", "k"))
			if(prob(50)) realName = replacetext(realName, "p", pick("b", "t"))

			var/datum/data/record/B = FindBankAccountByName(src.real_name)
			if (B && B.fields["name"])
				B.fields["name"] = realName

		C.registered = realName
		C.assignment = JOB.name
		C.name = "[C.registered]'s ID Card ([C.assignment])"
		C.access = JOB.access.Copy()

		if(src.bioHolder && src.bioHolder.HasEffect("fat"))
			src.equip_if_possible(C, slot_in_backpack)
		else
			src.equip_if_possible(C, slot_wear_id)

		if(src.pin)
			C.pin = src.pin

	for (var/obj/item/device/pda2/PDA in src.contents)
		PDA.owner = src.real_name
		PDA.name = "PDA-[src.real_name]"

	boutput(src, "<span style=\"color:blue\">Your pin to your ID is: [C.pin]</span>")
	if (src.mind)
		src.mind.store_memory("Your pin to your ID is: [C.pin]")

	if (wagesystem.jobs[JOB.name])
		src.equip_if_possible(new /obj/item/spacecash(src,wagesystem.jobs[JOB.name]), slot_r_store)
	else
		var/shitstore = rand(1,3)
		switch(shitstore)
			if(1)
				src.equip_if_possible(new /obj/item/pen(src), slot_r_store)
			if(2)
				src.equip_if_possible(new /obj/item/reagent_containers/food/drinks/water(src), slot_r_store)


//////////////////////////////////////////////
// cogwerks - personalized trinkets project //
/////////////////////////////////////////////

var/list/trinket_safelist = list(/obj/item/basketball,/obj/item/bikehorn, /obj/item/brick, /obj/item/clothing/glasses/eyepatch,
/obj/item/clothing/glasses/regular, /obj/item/clothing/glasses/sunglasses, /obj/item/clothing/gloves/boxing,
/obj/item/clothing/mask/horse_mask, /obj/item/clothing/mask/clown_hat, /obj/item/clothing/head/cowboy, /obj/item/clothing/shoes/cowboy, /obj/item/clothing/shoes/moon,
/obj/item/clothing/suit/sweater, /obj/item/clothing/suit/sweater/red, /obj/item/clothing/suit/sweater/green, /obj/item/clothing/suit/sweater/grandma, /obj/item/clothing/under/shorts,
/obj/item/clothing/under/suit/pinstripe, /obj/item/cigpacket, /obj/item/coin, /obj/item/crowbar,
/obj/item/dice, /obj/item/dice/d20, /obj/item/device/flashlight, /obj/item/device/key/random, /obj/item/extinguisher, /obj/item/firework,
/obj/item/football, /obj/item/material_piece/gold, /obj/item/harmonica, /obj/item/horseshoe,
/obj/item/kitchen/utensil/knife, /obj/item/raw_material/rock, /obj/item/pen/fancy, /obj/item/pen/odd, /obj/item/plant/herb/cannabis/spawnable,
/obj/item/razor_blade,/obj/item/rubberduck, /obj/item/saxophone, /obj/item/scissors, /obj/item/screwdriver, /obj/item/skull, /obj/item/stamp,
/obj/item/vuvuzela, /obj/item/wrench, /obj/item/zippo, /obj/item/reagent_containers/food/drinks/bottle/beer, /obj/item/reagent_containers/food/drinks/bottle/vintage,
/obj/item/reagent_containers/food/drinks/bottle/vodka, /obj/item/reagent_containers/food/drinks/rum, /obj/item/reagent_containers/food/drinks/bottle/hobo_wine/safe,
/obj/item/reagent_containers/food/snacks/burger, /obj/item/reagent_containers/food/snacks/burger/cheeseburger,
/obj/item/reagent_containers/food/snacks/burger/moldy,/obj/item/reagent_containers/food/snacks/candy/chocolate, /obj/item/reagent_containers/food/snacks/chips,
/obj/item/reagent_containers/food/snacks/cookie,/obj/item/reagent_containers/food/snacks/ingredient/egg,
/obj/item/reagent_containers/food/snacks/ingredient/egg/bee,/obj/item/reagent_containers/food/snacks/plant/apple,
/obj/item/reagent_containers/food/snacks/plant/banana, /obj/item/reagent_containers/food/snacks/plant/potato, /obj/item/reagent_containers/food/snacks/sandwich/pb,
/obj/item/reagent_containers/food/snacks/sandwich/cheese, /obj/item/reagent_containers/syringe/krokodil, /obj/item/reagent_containers/syringe/morphine,
/obj/item/reagent_containers/patch/LSD, /obj/item/reagent_containers/patch/nicotine, /obj/item/reagent_containers/glass/bucket, /obj/item/reagent_containers/glass/beaker,
/obj/item/reagent_containers/food/drinks/drinkingglass, /obj/item/reagent_containers/food/drinks/drinkingglass/shot,/obj/item/storage/pill_bottle/bathsalts,
/obj/item/storage/pill_bottle/catdrugs, /obj/item/storage/pill_bottle/crank, /obj/item/storage/pill_bottle/cyberpunk, /obj/item/storage/pill_bottle/methamphetamine,
/obj/item/spraybottle,/obj/item/staple_gun,/obj/item/clothing/head/NTberet,/obj/item/clothing/head/biker_cap, /obj/item/clothing/head/black, /obj/item/clothing/head/blue,
/obj/item/clothing/head/chav, /obj/item/clothing/head/det_hat, /obj/item/clothing/head/green, /obj/item/clothing/head/helmet/hardhat, /obj/item/clothing/head/merchant_hat,
/obj/item/clothing/head/mj_hat, /obj/item/clothing/head/red, /obj/item/clothing/head/that, /obj/item/clothing/head/wig, /obj/item/clothing/head/turban, /obj/item/dice/magic8ball,
/obj/item/reagent_containers/food/drinks/mug/random_color, /obj/item/reagent_containers/food/drinks/skull_chalice, /obj/item/pen/marker/random, /obj/item/pen/crayon/random)

var/list/trinket_names = list("'s dad's","'s mom's", "'s grampa's", "'s grandma's", "'s favorite", "'s trusty", "'s favorite", "'s heirloom", "'s pet",
"'s beloved", "'s lucky", "'s best", "'s antique", "'s old", "'s ol'", "'s prized", "'s neat", "'s good old", "'s good ol'", "'s son's", "'s daughter's",
"'s aunt's", "'s uncle's", "'s finest", "'s shiniest", "'s lovely", "'s stupid", "'s prize winning", "'s top shelf", "'s 'prize winning'", "'s 'top shelf'",
"'s autographed", "'s monogramed", "'s bejazzled", "'s jewel encrusted", "'s fanciest", "'s worn out", "'s custom", "'s luxurious", "'s superb", "'s precious")