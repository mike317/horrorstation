/mob/verb/join_the_hive()
	set category = "Special Verbs"
	set name = "Toggle Alien Spawn"

	if (istype(src, /mob/new_player))
		return 0

	src.client.preferences.be_xenomorph = 1

	if (!istype(src, /mob/dead))
		boutput(src, "<span style = \"color:red\">You will now spawn as any available Alien larvas when you die.</span>")
	else
		boutput(src, "<span style = \"color:red\">You will now spawn as an Alien larva.</span>")

/mob/verb/become_hugger()
	set category = "Special Verbs"
	set name = "Spawn As Facehugger"

	if (!istype(ticker.mode, /datum/game_mode/xeno))
		boutput(src, "<span style = \"color:red\">This is not an Xenomorph round.</span>")
		return

	else
		if (ticker.mode:alive_survivors() < 2)
			boutput(src, "<span style = \"color:red\">Spawning as a facehugger is currently impossible, because there aren't enough alive survivors. Ask an admin to be respawned as a survivor.</span>")
			return
//	if (world.time - client.time_since_last_hugger < 300 && client.time_since_last_hugger != -1)
	//	boutput(src, "<span style = \"color:red\"><b>You became a hugger too recently. Wait [(world.time - client.time_since_last_hugger)/60] more minutes.</span></b>")
	//	return 0

	if (istype(src, /mob/new_player))
		return 0

	if (isliving(src) || src.stat == 0 && !istype(src, /mob/dead) || src.stat == 1 && !istype(src, /mob/dead))
		boutput(src, "<span style = \"color:red\"><b>You are still alive.</span></b>")
		return 0

	for (var/obj/item/xeno/facehugger/f in world)
		if (prob(30))//don't spawn them as the first hugger
			if (f && f.loc && !istype(f.loc, /mob) && !istype(f.loc, /obj) && !locate(/mob) in f.loc)
				if (istype(f.loc, /turf))
					src.set_loc(f)
					src.xenomorphize("Facehugger")
					qdel(f)
					break

	if (!ishuman(src) || !src:mutantrace || !istype(src:mutantrace, /datum/mutantrace/xenomorph/larva/facehugger))
		for (var/obj/item/xeno/facehugger/f in world)
			if (f && f.loc && !istype(f.loc, /mob) && !istype(f.loc, /obj) && !locate(/mob) in f.loc)
				if (istype(f.loc, /turf))
					src.set_loc(f)
					src.xenomorphize("Facehugger")
					qdel(f)
					break

	if (!ishuman(src))
		boutput(src, "<span style = \"color:red\"><b>You failed to spawn as a facehugger; none were available.</span></b>")
		return

	if (isAlienHugger(src))
		client.time_since_last_hugger = world.time