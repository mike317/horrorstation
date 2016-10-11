
/obj/landmark
	name = "landmark"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x2"
	anchored = 1.0

	ex_act()
		return

/obj/landmark/cruiser_entrance

/obj/landmark/alterations
	name = "alterations"

/obj/landmark/miniworld
	name = "worldsetup"
	var/id = 0

/obj/landmark/miniworld/w1

/obj/landmark/miniworld/w2

/obj/landmark/miniworld/w3

/obj/landmark/miniworld/w4


/obj/landmark/New()

	..()

	if (istype(src, /obj/landmark/loot_spawn))
		src:init()

	src.tag = "landmark*[src.name]"
	src.invisibility = 100//was 101. 100 is better since it probably allows us to use this obj's variables and stuff

	if (name == "shuttle")
		shuttle_z = src.z
		qdel(src)
/*
	if (name == "airtunnel_stop")
		airtunnel_stop = src.x

	if (name == "airtunnel_start")
		airtunnel_start = src.x

	if (name == "airtunnel_bottom")
		airtunnel_bottom = src.y
*/
	if (name == "monkey")
		monkeystart += src.loc
		qdel(src)

	if (name == "start")
		newplayer_start += src.loc
		qdel(src)

	if (name == "wizard")
		wizardstart += src.loc
		qdel(src)

	if (name == "predator")
		predstart += src.loc
		qdel(src)

	if (name == "Syndicate-Spawn")
		syndicatestart += src.loc
		qdel(src)

	if (name == "SR Syndicate-Spawn")
		syndicatestart += src.loc
		qdel(src)

	if (name == "JoinLate")
		latejoin += src.loc
		qdel(src)

	if (name == "Observer-Start")
		observer_start += src.loc
		qdel(src)

	if (name == "Xeno-Start")
	/*
		if (xeno_start.len < 5)
			xeno_start += src.loc
			qdel(src)
		else
			survivor_start += src.loc
			qdel(src)
			*/
		xeno_start += src.loc

		if (prob(50))
			var/mob/living/carbon/human/npc/monkey/m = new/mob/living/carbon/human/npc/monkey(src.loc)
			m.sedated = 1
			if (prob(50))
				m = new/mob/living/carbon/human/npc/monkey(src.loc)
				m.sedated = 1

		qdel(src)

	if (name == "Warehouse-Start")
		survivor_start += src.loc

		if (prob(90))
			new/mob/living/carbon/human/npc/monkey(src.loc)
		if (prob(90))
			new/mob/living/carbon/human/npc/monkey(src.loc)
		if (prob(90))
			new/mob/living/carbon/human/npc/monkey(src.loc)

		for (var/mob/living/carbon/human/npc/monkey/m in src.loc)
			m.sedated = 1

		qdel(src)

	if (name == "Loot-Spawn")

		if (prob(70))
			qdel(src)//so nobody is messaged about it
			return

		src.layer = -1

		var/probability_common = 70
		var/probability_uncommon = 50
		var/probability_rare = 20

		if (src:loot_first)
			switch (src:loot_first)
				if ("Weaponry")

					var/amount = 10
					var/got_cap_laser = 0

					if (prob(probability_common))
						amount += 5

					if (prob(probability_uncommon))
						amount += 7

					if (prob(probability_rare))
						amount += 10

					for (var/i = 1, i <= amount, i++)
						var/spawnloc = locate(src.x+rand(-2,2),src.y+rand(-2,2),src.z)//we have to assume that it will spawn
						//in a fairly small area sometimes
						if (!istype(spawnloc, /turf/simulated/floor))
							continue

						if (prob(20))
							new/obj/item/gun/energy/taser_gun(spawnloc)
						if (prob(15))
							new/obj/item/gun/energy/laser_gun(spawnloc)
						if (prob(13) && !got_cap_laser)
							new/obj/item/gun/energy/laser_gun/antique(spawnloc)
							got_cap_laser = 1
						if (prob(11))
							new/obj/item/gun/energy/egun(spawnloc)

						if (prob(10))
							new/obj/item/gun/energy/phaser_gun(spawnloc)

						if (prob(8))
							new/obj/item/gun/energy/wavegun(spawnloc)

						if (prob(5))

							new/obj/item/ammo/bullets/derringer(spawnloc)

						if (prob(5))
							new/obj/item/ammo/bullets/custom(spawnloc)

						if (prob(5))
							new/obj/item/ammo/bullets/a357(spawnloc)

						if (prob(5))
							new/obj/item/gun/kinetic/revolver(spawnloc)

						if (prob(5))
							new/obj/item/gun/kinetic/derringer(spawnloc)

				//		if (prob(2))
					//		new/obj/item/gun/energy/bfg(spawnloc)
				if ("Food")
					var/max_meat = rand(10,20)
					for (var/v = 1, v <= max_meat, v++)
						var/spawnloc = locate(src.x+rand(-2,2),src.y+rand(-2,2),src.z)
						if (!istype(spawnloc, /turf/simulated/floor))
							continue

						var/obj/item/reagent_containers/food/snacks/ingredient/meat/monkeymeat/m = new/obj/item/reagent_containers/food/snacks/ingredient/meat/monkeymeat(spawnloc)
						m.salt()


				if ("Meds")
					var/max_meds = rand(10,20)
					for (var/v = 1, v <= max_meds, v++)
						var/spawnloc = locate(src.x+rand(-2,2),src.y+rand(-2,2),src.z)
						if (!istype(spawnloc, /turf/simulated/floor))
							continue

						if (prob(80))
							new/obj/item/reagent_containers/patch/synthflesh(spawnloc)
						if (prob(60))
							new/obj/item/reagent_containers/patch/mini/bruise(spawnloc)
						if (prob(40))
							new/obj/item/reagent_containers/patch/mini/burn(spawnloc)
						if (prob(10))
							new/obj/item/reagent_containers/patch/mini/omnipatch(spawnloc)
						if (prob(30))
							new/obj/item/reagent_containers/patch/mini/antifoodpoisoningpatch(spawnloc)
						if (prob(30))
							new/obj/item/reagent_containers/patch/mini/antitoxinpatch(spawnloc)


		if (src:loot_second)
			switch (src:loot_second)
				if ("Weaponry")

					var/amount = 10
					var/got_cap_laser = 0

					if (prob(probability_common))
						amount += 5

					if (prob(probability_uncommon))
						amount += 7

					if (prob(probability_rare))
						amount += 10

					for (var/i = 1, i <= amount, i++)
						var/spawnloc = locate(src.x+rand(-2,2),src.y+rand(-2,2),src.z)//we have to assume that it will spawn
						//in a fairly small area sometimes
						if (!istype(spawnloc, /turf/simulated/floor))
							continue

						if (prob(20))
							new/obj/item/gun/energy/taser_gun(spawnloc)
						if (prob(15))
							new/obj/item/gun/energy/laser_gun(spawnloc)
						if (prob(13) && !got_cap_laser)
							new/obj/item/gun/energy/laser_gun/antique(spawnloc)
							got_cap_laser = 1
						if (prob(11))
							new/obj/item/gun/energy/egun(spawnloc)

						if (prob(10))
							new/obj/item/gun/energy/phaser_gun(spawnloc)

						if (prob(8))
							new/obj/item/gun/energy/wavegun(spawnloc)

						if (prob(5))

							new/obj/item/ammo/bullets/derringer(spawnloc)

						if (prob(5))
							new/obj/item/ammo/bullets/custom(spawnloc)

						if (prob(5))
							new/obj/item/ammo/bullets/a357(spawnloc)

						if (prob(5))
							new/obj/item/gun/kinetic/revolver(spawnloc)

						if (prob(5))
							new/obj/item/gun/kinetic/derringer(spawnloc)

				//		if (prob(2))
						//	new/obj/item/gun/energy/bfg(spawnloc)
				if ("Food")
					var/max_meat = rand(10,20)
					for (var/v = 1, v <= max_meat, v++)
						var/spawnloc = locate(src.x+rand(-2,2),src.y+rand(-2,2),src.z)
						if (!istype(spawnloc, /turf/simulated/floor))
							continue

						var/obj/item/reagent_containers/food/snacks/ingredient/meat/monkeymeat/m = new/obj/item/reagent_containers/food/snacks/ingredient/meat/monkeymeat(spawnloc)
						m.salt()


				if ("Meds")
					var/max_meds = rand(10,20)
					for (var/v = 1, v <= max_meds, v++)
						var/spawnloc = locate(src.x+rand(-2,2),src.y+rand(-2,2),src.z)
						if (!istype(spawnloc, /turf/simulated/floor))
							continue

						if (prob(80))
							new/obj/item/reagent_containers/patch/synthflesh(spawnloc)
						if (prob(60))
							new/obj/item/reagent_containers/patch/mini/bruise(spawnloc)
						if (prob(40))
							new/obj/item/reagent_containers/patch/mini/burn(spawnloc)
						if (prob(10))
							new/obj/item/reagent_containers/patch/mini/omnipatch(spawnloc)
						if (prob(30))
							new/obj/item/reagent_containers/patch/mini/antifoodpoisoningpatch(spawnloc)
						if (prob(30))
							new/obj/item/reagent_containers/patch/mini/antitoxinpatch(spawnloc)

	/*

	if (name == "Cherkir-Critter-Start")
		cherkir_critter_start += src.loc
		qdel(src)
		*/

	if (name == "shitty_bill")
		spawn(30)
			new /mob/living/carbon/human/biker(src.loc)
			qdel(src)

	if (name == "father_jack")
		spawn(30)
			new /mob/living/carbon/human/fatherjack(src.loc)
			qdel(src)

	if (name == "don_glab")
		spawn(30)
			new /mob/living/carbon/human/don_glab(src.loc)
			qdel(src)

	if (name == "monkeyspawn_normal")
		spawn(60)
			new /mob/living/carbon/human/npc/monkey(src.loc)
			qdel(src)

	if (name == "monkeyspawn_albert")
		spawn(60)
			new /mob/living/carbon/human/npc/monkey/albert(src.loc)
			qdel(src)

	if (name == "monkeyspawn_rathen")
		spawn(60)
			new /mob/living/carbon/human/npc/monkey/mr_rathen(src.loc)
			qdel(src)

	if (name == "monkeyspawn_mrmuggles")
		spawn(60)
			new /mob/living/carbon/human/npc/monkey/mr_muggles(src.loc)
			qdel(src)

	if (name == "monkeyspawn_mrsmuggles")
		spawn(60)
			new /mob/living/carbon/human/npc/monkey/mrs_muggles(src.loc)
			qdel(src)

	if (name == "monkeyspawn_syndicate")
		spawn(60)
			new /mob/living/carbon/human/npc/monkey/von_braun(src.loc)
			qdel(src)

	if (name == "monkeyspawn_horse")
		spawn(60)
			new /mob/living/carbon/human/npc/monkey/horse(src.loc)
			qdel(src)

	if (name == "monkeyspawn_krimpus")
		spawn(60)
			new /mob/living/carbon/human/npc/monkey/krimpus(src.loc)
			qdel(src)

	if (name == "monkeyspawn_tanhony")
		spawn(60)
			new /mob/living/carbon/human/npc/monkey/tanhony(src.loc)
			qdel(src)

	if (name == "Clown")
		clownstart += src.loc
		//dispose()

	//prisoners
	if (name == "prisonwarp")
		prisonwarp += src.loc
		qdel(src)
	//if (name == "mazewarp")
	//	mazewarp += src.loc
	if (name == "tdome1")
		tdome1	+= src.loc
	if (name == "tdome2")
		tdome2 += src.loc
	//not prisoners
	if (name == "prisonsecuritywarp")
		prisonsecuritywarp += src.loc
		qdel(src)

	if (name == "blobstart")
		blobstart += src.loc
		qdel(src)
	if (name == "kudzustart")
		kudzustart += src.loc
		qdel(src)

	if (name == "telesci")
		telesci += src.loc
		qdel(src)

	if (name == "icefall")
		icefall += src.loc
		qdel(src)

	if (name == "deepfall")
		deepfall += src.loc
		qdel(src)

	if (name == "ancientfall")
		ancientfall += src.loc
		qdel(src)

	if (name == "iceelefall")
		iceelefall += src.loc
		qdel(src)

	if (name == "bioelefall")
		bioelefall += src.loc
		qdel(src)

	return 1

var/global/list/job_start_locations = list()

/obj/landmark/start
	name = "start"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"
	anchored = 1.0

	New()
		..()
		src.tag = "start*[src.name]"
		if (job_start_locations)
			if (!islist(job_start_locations[src.name]))
				job_start_locations[src.name] = list(src)
			else
				job_start_locations[src.name] += src
		src.invisibility = 101
		return 1

/obj/landmark/start/xenostart
	name = "Xeno-Start"//should prevent other jobs from spawning at it

/obj/landmark/start/cherkir_critter_start
	name = "Cherkir-Critter-Start"

/obj/landmark/start/warehousestart
	name = "Warehouse-Start"

/obj/landmark/start/latejoin
	name = "JoinLate"

/obj/landmark/tutorial_start
	name = "Tutorial Start Marker"

/obj/landmark/asteroid_spawn_blocker //Blocks the creation of an asteroid on this tile, as you would expect
	name = "asteroid blocker"
	icon_state = "x4"

/obj/landmark/magnet_center
	name = "magnet center"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"
	anchored = 1.0

/obj/landmark/magnet_shield
	name = "magnet shield"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"
	anchored = 1.0

/obj/landmark/loot_spawn
	name = "Loot-Spawn"
	anchored = 1.0
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x2"
	var/loot_first
	var/loot_second
	var/possible_loot = list("Weaponry", "Food", "Meds")

	var/loot_first_name
	var/loot_second_name


	proc/init()//using this instead of New() because if I call landmark's new first, it will try to set up stuff
	//with null values, but if I call it second, this won't have any location - Cherkir
		loot_first = pick(possible_loot)
		if (prob(40))
			loot_second = pick(possible_loot)

		switch (loot_first)
			if ("Weaponry")
				loot_first_name = "weapon"
			if ("Food")
				loot_first_name = "food"
			if ("Meds")
				loot_first_name = "medical supplie"//no this is NOT a typo, an s is added
			else
				loot_first_name = ""

		switch (loot_second)
			if ("Weaponry")
				loot_second_name = "weapon"
			if ("Food")
				loot_second_name = "food"
			if ("Meds")
				loot_second_name = "medical supplie"
			else
				loot_second_name = ""
