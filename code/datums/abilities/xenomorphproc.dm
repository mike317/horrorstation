mob/living/carbon/human/var/xeno_no_plasma_change_flag = 0
mob/living/carbon/human/var/xeno_no_health_change_flag = 0
mob/living/carbon/human/var/xeno_no_heat_change_flag = 0
mob/living/carbon/human/var/xeno_no_stamina_change_flag = 0
mob/living/carbon/human/var/xeno_no_semievo_change_flag = 0
mob/living/carbon/human/var/xeno_no_fullevo_change_flag = 0


/mob/living/carbon/human/proc/ambient_xeno_update(var/plasmaChange = 0, var/healthChange = 0, var/heatChange = 0, var/staminaChange = 0, var/evoChange = 0, var/showMaxMessages = 0)
	if (plasmaChange && !xeno_no_plasma_change_flag)

		if (src.mutantrace:plasma <= 0)
			src.ambient_xeno_message("noplasma")

		else if (src.mutantrace:plasma/src.mutantrace:maxPlasma < 0.5)

			if (src.mutantrace:plasma/src.mutantrace:maxPlasma < 0.2)//if you're at 20% or less plasma
				src.ambient_xeno_message("lowplasma")
			else
				src.ambient_xeno_message("medplasma")

		else if (src.mutantrace:plasma/src.mutantrace:maxPlasma > 0.9)

			if (src.mutantrace:plasma/src.mutantrace:maxPlasma < 1.0)
				src.ambient_xeno_message("highplasma")
			else
				if (showMaxMessages)
					src.ambient_xeno_message("maxplasma")

	if (healthChange && !xeno_no_health_change_flag)

		if (src.health <= 0)
			src.ambient_xeno_message("nohealth")//rip.

		else if (src.health/src.max_health > 0.5)

			if (src.health/src.max_health < 0.2)//if you're at 20% or less plasma
				src.ambient_xeno_message("lowhealth")
			else
				src.ambient_xeno_message("medhealth")

		else if (src.health/src.max_health > 0.9)

			if (src.health/src.max_health < 1.0)
				src.ambient_xeno_message("highhealth")
			else
				if (showMaxMessages)
					src.ambient_xeno_message("maxhealth")

	if (heatChange && !xeno_no_heat_change_flag)

		heatChange = src.get_temp_deviation()
		switch (heatChange)//1 to 4 based on heat


			if (1)
				src.ambient_xeno_message("nofire")
			if (2)
				src.ambient_xeno_message("lowplasma")
			if (3)
				src.ambient_xeno_message("medfire")

			if (4)
				if (prob(30))
					//no showMaxMessages check for this, because I don't mind it repeating
					src.ambient_xeno_message("maxfire")
				else
					src.ambient_xeno_message("highfire")

	if (staminaChange && !xeno_no_stamina_change_flag)

		if (src.get_stamina()/src.get_max_stamina() <= 0)
			src.ambient_xeno_message("nostamina")//rip.

		else if (src.get_stamina()/src.get_max_stamina() > 0.5)

			if (src.get_stamina()/src.get_max_stamina() < 0.2)//if you're at 20% or less plasma
				src.ambient_xeno_message("lowstamina")
			else
				src.ambient_xeno_message("medstamina")

		else if (src.get_stamina()/src.get_max_stamina() > 0.9)

			if (src.get_stamina()/src.get_max_stamina() < 1.0)
				src.ambient_xeno_message("highstamina")
			else
				if (showMaxMessages)
					src.ambient_xeno_message("maxstamina")

	if (evoChange)
		if (src.mutantrace:evoProgress/src.mutantrace:maxEvoProgress > 0.95)
			if (src.mutantrace:evoProgress/src.mutantrace:maxEvoProgress < 1.0)
				if (!xeno_no_semievo_change_flag)
					src.ambient_xeno_message("almostevotime")
			else
				if (!xeno_no_fullevo_change_flag)
					if (showMaxMessages)
						src.ambient_xeno_message("evotime")

	if (plasmaChange)
		xeno_no_plasma_change_flag = 1
		spawn (100)
			xeno_no_plasma_change_flag = 0

	if (healthChange)
		xeno_no_health_change_flag = 1
		spawn (100)
			xeno_no_health_change_flag = 0

	if (heatChange)
		xeno_no_heat_change_flag = 1
		spawn (100)
			xeno_no_heat_change_flag = 0

	if (staminaChange)
		xeno_no_stamina_change_flag = 1
		spawn (100)
			xeno_no_stamina_change_flag = 0

	if (evoChange == 1)
		xeno_no_semievo_change_flag = 1
		spawn (100)
			xeno_no_semievo_change_flag = 0

	if (evoChange == 2)
		xeno_no_fullevo_change_flag = 1
		spawn (100)
			xeno_no_fullevo_change_flag = 0


/mob/living/carbon/human/proc/get_new_xenomorph_name()

	var/previous_num = 0

	if (findtext(src.real_name, "Alien"))
		previous_num = text2list(src.real_name, " ")
		previous_num = previous_num[3]
		previous_num = text2num(previous_num)

		if (!previous_num || !isnum(previous_num))
			previous_num = rand(1,1000)
	else
		previous_num = rand(1,1000)


	if (previous_num == 0 || !previous_num || !isnum(previous_num) || previous_num == null)
		previous_num = rand(1,1000)


	if (istype(src.mutantrace, /datum/mutantrace/xenomorph/larva))

		if (istype(src.mutantrace, /datum/mutantrace/xenomorph/larva/facehugger))

			return "Alien Facehugger [previous_num]"

		return "Alien Chestburster [previous_num]"

	else if (istype(src.mutantrace, /datum/mutantrace/xenomorph/drone))

		if (istype(src.mutantrace, /datum/mutantrace/xenomorph/drone/queen))

			if (!istype(src.mutantrace, /datum/mutantrace/xenomorph/drone/queen/empress))

				return "Alien Queen"

			else

				return "Alien Empress"
		else
			return "Alien Drone [previous_num]"


	else if (istype(src.mutantrace, /datum/mutantrace/xenomorph/sentinel))

		return "Alien Sentinel [previous_num]"

	else if (istype(src.mutantrace, /datum/mutantrace/xenomorph/warrior))

		return "Alien Warrior [previous_num]"

	else if (istype(src.mutantrace, /datum/mutantrace/xenomorph/praetorian))

		return "Alien Praetorian [previous_num]"



	return "Alien Drone [rand(1,1000)]"

/mob/proc/make_true_xenomorph(var/queen = 0, var/newxeno = 0, var/caste)

	if (!src.client || !src.mind)
		return 0


	var/mob/living/carbon/human/H = new/mob/living/carbon/human(src)
	H.loc = src.loc

	if (H.client)
		H.hud = null
		H.zone_sel = null
		H.stamina_bar = null

		H.xenoHud = new(src)
		H.attach_hud(H.xenoHud)
		H.zone_sel = new(src)
		H.attach_hud(zone_sel)
		H.stamina_bar = new(src)
		H.xenoHud.add_object(src.stamina_bar, HUD_LAYER+1, "EAST-1, NORTH")

	H.alien_egg_flag = 1//prevents you from being facehugged by your allies
	H.blood_color = "#A2AD2A"


	if (src.mind)
		src.mind.transfer_to(H)
	else
		var/key = src.client.key
		if (src.client)
			src.client.mob = H
		H.mind = new /datum/mind()
		H.mind.key = key
		H.mind.current = H
		ticker.minds += H.mind


	var/this = src
	src = null
	qdel(this)

	if (H.mind && H.mind.special_role != "truexeno")//"xeno" is used for spawning, "truexeno"
	//represents actual players who have become xenomorphs and is used for game end checks
		H.mind.special_role = "truexeno"

	H.mind.assigned_role = "MODE"

	H.bioHolder = new/datum/bioHolder(H)//get rid of previous bioholders

	if (istype(ticker.mode, /datum/game_mode/xeno))
		switch (caste)
			if ("sentinel", "Sentinel")
				ticker.mode:was_alien_sentinel++
			if ("warrior", "Warrior")
				ticker.mode:was_alien_warrior++
			if ("praetorian", "Praetorian")
				ticker.mode:was_alien_praetorian++
			if ("queen", "Queen")
				ticker.mode:was_alien_queen++

		if (queen)
			ticker.mode:was_alien_queen++

	if (!caste)
		if (!queen)
			if (newxeno)
				H.bioHolder.AddEffect("xlarva")
			else
				H.bioHolder.AddEffect("xdrone")
		else//newxeno check here to make fresh larvae
			H.bioHolder.AddEffect("xqueen")
	else
		H.bioHolder.AddEffect("x[lowertext(caste)]")

	var/datum/abilityHolder/xenomorph/O = H.get_ability_holder(/datum/abilityHolder/xenomorph)
	if (O)
		return

	var/show_alien_html = 1

	for (var/mob/living/carbon/human/humie in range(20, H))
		if (!isAlien(humie))
			show_alien_html = 0
			break

	if (H.mind && !H.mind.is_xenomorph && show_alien_html && (H.mind.special_role != "omnitraitor"))
	//if (H.mind)
		H << browse(grabResource("html/traitorTips/xenoTips.html"),"window=antagTips;titlebar=1;size=600x400;can_minimize=0;can_resize=0")

	H.abilityHolder = new/datum/abilityHolder/composite(H)//get rid of previous ability holders


	var/datum/abilityHolder/xenomorph/X = H.add_ability_holder(/datum/abilityHolder/xenomorph)

	var/islarva = 0

	if (!caste && newxeno && !queen)
		islarva = 1


	X.addAbility(/datum/targetable/xenomorph/bioflashlight)

	if (H.mutantrace:bigXeno == 0)
		X.addAbility(/datum/targetable/xenomorph/vent_crawl)
		if (caste == "Facehugger" || caste == "facehugger")
			X.addAbility(/datum/targetable/xenomorph/squeeze)
		if (caste == "Facehugger" || caste == "Larva" || caste == "facehugger" || caste == "larva")
			X.addAbility(/datum/targetable/xenomorph/hide)
		if (islarva)
			X.addAbility(/datum/targetable/xenomorph/hide)

	if (caste != "Facehugger" && caste != "facehugger")
		if (!queen && caste != "Warrior" && caste != "warrior" && caste != "Praetorian" && caste != "praetorian")
			X.addAbility(/datum/targetable/xenomorph/evolve)

	if (caste != "Facehugger" && caste != "facehugger" && caste != "Larva" && caste != "larva" && !islarva)

		X.addAbility(/datum/targetable/xenomorph/build_with_resin)

		X.addAbility(/datum/targetable/xenomorph/devour)

		X.addAbility(/datum/targetable/xenomorph/rend)

		//if (H.mutantrace:bigXeno == 0)
		//	X.addAbility(/datum/targetable/xenomorph/leap_toggle)

		if (isAlienDrone(H))
			X.addAbility(/datum/targetable/xenomorph/weed)
			X.addAbility(/datum/targetable/xenomorph/secrete_resin)


		if (isAlienQueen(H))
			X.addAbility(/datum/targetable/xenomorph/build_egg)

		if (isAlienDrone(H) || isAlienPraetorian(H))
			X.addAbility(/datum/targetable/xenomorph/release_pheromones)

		if (H.mind)
			H.mind.is_xenomorph = X

	if (lowertext(caste) == "warrior")
		X.addAbility(/datum/targetable/xenomorph/penetrate)
		X.addAbility(/datum/targetable/xenomorph/tailimpale)
	if (lowertext(caste) == "sentinel" || lowertext(caste) == "praetorian")
		X.addAbility(/datum/targetable/xenomorph/spit)
		X.addAbility(/datum/targetable/xenomorph/kamikaze)
		X.addAbility(/datum/targetable/xenomorph/secrete_acid_cloud)
		X.addAbility(/datum/targetable/xenomorph/secrete_acid)
		if (lowertext(caste) == "praetorian")
			X.addAbility(/datum/targetable/xenomorph/rip_apart)
			X.addAbility(/datum/targetable/xenomorph/slam)
			X.addAbility(/datum/targetable/xenomorph/crush)
			X.addAbility(/datum/targetable/xenomorph/tailwhip)

	H.name = H.get_new_xenomorph_name()
	H.real_name = H.name
/*

	var/spawnlist[0]

	for (var/obj/landmark/start/xenostart/xspawn in world)
		spawnlist += xspawn

	H.set_loc(pick(spawnlist))
*/
	H.unequip_all()

	H.r_store = null
	H.l_store = null

	H.wear_suit = null
	H.w_uniform = null
//	var/obj/item/device/radio/w_radio = null
	H.shoes = null
	H.belt = null
	H.gloves = null
	H.glasses = null
	H.head = null
	//var/obj/item/card/id/wear_id = null
	H.wear_id = null



	if (!newxeno)
		H.set_loc(pick(xeno_start))
	//	playSoundToClient(H.mutantrace:sound_alienroar0)
	//	xeno_spawn_locations += H.loc
	//else
	//	playSoundToClient(H.mutantrace:sound_alienroar0)

	H << H.mutantrace:sound_alienroar0

	H.update_alien_light()


//	H.overlays = null
/*

	H.image_eyes = image('icons/tg-goon-xenos/no-xeno-icon.dmi', layer = TURF_LAYER)
	H.image_cust_one = image('icons/tg-goon-xenos/no-xeno-icon.dmi', layer = TURF_LAYER)
	H.image_cust_two = image('icons/tg-goon-xenos/no-xeno-icon.dmi', layer = TURF_LAYER)
	H.image_cust_three = image('icons/tg-goon-xenos/no-xeno-icon.dmi', layer = TURF_LAYER)

//	H.human_image = image('icons/tg-goon-xenos/no-xeno-icon.dmi')
//	H.human_head_image = image('icons/tg-goon-xenos/no-xeno-icon.dmi')
	H.human_untoned_image = image('icons/tg-goon-xenos/no-xeno-icon.dmi')
	H.human_decomp_image = image('icons/tg-goon-xenos/no-xeno-icon.dmi')
	H.human_untoned_decomp_image = image('icons/tg-goon-xenos/no-xeno-icon.dmi')

	H.undies_image = image('icons/tg-goon-xenos/no-xeno-icon.dmi') //, layer = MOB_UNDERWEAR_LAYER)
	H.bandage_image = image('icons/tg-goon-xenos/no-xeno-icon.dmi', "layer" = TURF_LAYER)
	H.blood_image = image('icons/tg-goon-xenos/no-xeno-icon.dmi', "layer" = TURF_LAYER)
	H.handcuff_img = image('icons/tg-goon-xenos/no-xeno-icon.dmi')
	H.shield_image = image('icons/tg-goon-xenos/no-xeno-icon.dmi', "icon_state" = "shield")
	H.heart_image = image('icons/tg-goon-xenos/no-xeno-icon.dmi')
	H.heart_emagged_image = image('icons/tg-goon-xenos/no-xeno-icon.dmi', "layer" = TURF_LAYER)
	H.spider_image = image('icons/tg-goon-xenos/no-xeno-icon.dmi', "layer" = TURF_LAYER)
	H.nested_image = image('icons/tg-goon-xenos/no-xeno-icon.dmi', "icon_state" = "nestoverlay")
	H.juggle_image = image('icons/tg-goon-xenos/no-xeno-icon.dmi', "layer" = TURF_LAYER)
*/
	return H

/mob/living/carbon/human/proc/update_xeno_icon(var/toLeap = 0)

	if (bioHolder && isAlien(src))

		var/evo = "Drone"

		if (istype(mutantrace, /datum/mutantrace/xenomorph/sentinel))
			evo = "Sentinel"
		if (istype(mutantrace, /datum/mutantrace/xenomorph/warrior))
			evo = "Warrior"
		if (istype(mutantrace, /datum/mutantrace/xenomorph/praetorian))
			evo = "Praetorian"
		if (istype(mutantrace, /datum/mutantrace/xenomorph/drone/queen))
			evo = "Queen"
		if (istype(mutantrace, /datum/mutantrace/xenomorph/drone/queen/empress))
			evo = "Empress"

		var/oldplasma = mutantrace:plasma
		var/oldmaxPlasma = mutantrace:maxPlasma
		var/oldevoPlasma = mutantrace:evoPlasma
		var/oldevoTime = mutantrace:evoTime

		var/oldevoProgress = mutantrace:evoProgress
		var/oldmaxEvoProgress = mutantrace:maxEvoProgress

		var/oldRHand = r_hand
		var/oldLHand = l_hand

		if (toLeap)
			xSetMobEvolution(evo, -1)//make them re-evolve into their current form, with a leaping icon.
		else
			xSetMobEvolution(evo, -2)//make them re-evolve into their current form, with a normal icon.

		mutantrace:plasma = oldplasma
		mutantrace:maxPlasma = oldmaxPlasma
		mutantrace:evoPlasma = oldevoPlasma
		mutantrace:evoTime = oldevoTime
		mutantrace:evoProgress = oldevoProgress
		mutantrace:maxEvoProgress = oldmaxEvoProgress

		r_hand = oldRHand
		l_hand = oldLHand

/mob/living/carbon/human/proc/update_xeno_abilities()

	var/datum/abilityHolder/xenomorph/X = src.get_ability_holder(/datum/abilityHolder/xenomorph)

	if (!X)
		return 0

	//remove everything because you've already evolved into a new caste here
	X.removeAbility(/datum/targetable/xenomorph/build_with_resin)
	X.removeAbility(/datum/targetable/xenomorph/devour)
	X.removeAbility(/datum/targetable/xenomorph/leap_toggle)
	X.removeAbility(/datum/targetable/xenomorph/evolve)
	X.removeAbility(/datum/targetable/xenomorph/vent_crawl)
	X.removeAbility(/datum/targetable/xenomorph/weed)
	X.removeAbility(/datum/targetable/xenomorph/secrete_resin)
	X.removeAbility(/datum/targetable/xenomorph/build_egg)
	X.removeAbility(/datum/targetable/xenomorph/hide)
	X.removeAbility(/datum/targetable/xenomorph/squeeze)

	X.removeAbility(/datum/targetable/xenomorph/rend)
	X.removeAbility(/datum/targetable/xenomorph/penetrate)
	X.removeAbility(/datum/targetable/xenomorph/tailimpale)
	X.removeAbility(/datum/targetable/xenomorph/rip_apart)
	X.removeAbility(/datum/targetable/xenomorph/spit)
	X.removeAbility(/datum/targetable/xenomorph/slam)
	X.removeAbility(/datum/targetable/xenomorph/crush)
	X.removeAbility(/datum/targetable/xenomorph/tailwhip)
	X.removeAbility(/datum/targetable/xenomorph/bioflashlight)
	X.removeAbility(/datum/targetable/xenomorph/kamikaze)
	X.removeAbility(/datum/targetable/xenomorph/release_pheromones)
	X.removeAbility(/datum/targetable/xenomorph/secrete_acid_cloud)
	X.removeAbility(/datum/targetable/xenomorph/secrete_acid)

	X.addAbility(/datum/targetable/xenomorph/bioflashlight)

	if (!isAlienHugger(src))
		X.addAbility(/datum/targetable/xenomorph/build_with_resin)
		X.addAbility(/datum/targetable/xenomorph/devour)
	//	if (src.mutantrace:bigXeno == 0)
	//		X.addAbility(/datum/targetable/xenomorph/leap_toggle)
		X.addAbility(/datum/targetable/xenomorph/evolve)

		X.addAbility(/datum/targetable/xenomorph/rend)



	else
		X.addAbility(/datum/targetable/xenomorph/hide)
		X.addAbility(/datum/targetable/xenomorph/squeeze)

	if (isAlienLarva(src))
		X.addAbility(/datum/targetable/xenomorph/hide)


	if (src.mutantrace:bigXeno == 0)
		X.addAbility(/datum/targetable/xenomorph/vent_crawl)

	if (!isAlienHugger(src))
		if (isAlienDrone(src))
			X.addAbility(/datum/targetable/xenomorph/secrete_resin)
			X.addAbility(/datum/targetable/xenomorph/weed)

		if (isAlienQueen(src))
			X.addAbility(/datum/targetable/xenomorph/build_egg)

		if (isAlienDrone(src) || isAlienPraetorian(src))
			X.addAbility(/datum/targetable/xenomorph/release_pheromones)

	if (isAlienWarrior(src))
		X.addAbility(/datum/targetable/xenomorph/penetrate)
		X.addAbility(/datum/targetable/xenomorph/tailimpale)

	if (isAlienSentinel(src) || isAlienPraetorian(src))
		X.addAbility(/datum/targetable/xenomorph/spit)
		X.addAbility(/datum/targetable/xenomorph/kamikaze)
		X.addAbility(/datum/targetable/xenomorph/secrete_acid)
		X.addAbility(/datum/targetable/xenomorph/secrete_acid_cloud)

	if (isAlienPraetorian(src))
		X.addAbility(/datum/targetable/xenomorph/rip_apart)
		X.addAbility(/datum/targetable/xenomorph/slam)
		X.addAbility(/datum/targetable/xenomorph/crush)
		X.addAbility(/datum/targetable/xenomorph/tailwhip)

/mob/living/carbon/human/proc/xSetMobEvolution(var/e, var/devolution = 0, var/admintransed = 0)//the code below is almost pure copypaste from transform_procs, xenomorphize()
														//devolution being set to -1 causes the icon to be a leaping one.
																//admintransed being 1 allows changing to ALL
																//castes, and skips delays.
	if (!mutantrace || !istype(mutantrace, /datum/mutantrace/xenomorph))
		return 0

//	var/plasma_multiplier = mutantrace:maxPlasma/initial(mutantrace:maxPlasma)//how much plasma have they gained by eating organs?
		//if this is under 1, that's weird

	var/plasma_addition = mutantrace:maxPlasma - initial(mutantrace:maxPlasma)

	if (devolution != -1 && devolution != -2)
		if (e == "Queen")
			for (var/mob/m in mobs)
				if (isAlien(m) && m.stat != 2)
					if (istype(m:mutantrace, /datum/mutantrace/xenomorph/drone/queen))
						boutput(m, "<span style = \"color:red\"><b>There is already a Queen.</span></b>")
						return

	var/whatToRemove

	if (devolution == -1)
		switch (e)
			if ("Drone")
				whatToRemove = "xdrone"
			if ("Sentinel")
				whatToRemove = "xsentinel"
			if ("Warrior")
				whatToRemove = "xwarrior"
			if ("Praetorian")
				whatToRemove = "xpraetorian"
			if ("Queen")
				whatToRemove = "xqueen"
			if ("Empress")
				whatToRemove = "xempress"

	else if (devolution == -2)
		switch (e)
			if ("Drone")
				whatToRemove = "xdronel"
			if ("Sentinel")
				whatToRemove = "xsentinell"
			if ("Warrior")
				whatToRemove = "xwarriorl"
			if ("Praetorian")
				whatToRemove = "xpraetorian"
			if ("Queen")
				whatToRemove = "xqueen"
			if ("Empress")
				whatToRemove = "xempress"
			//finish this
			//add removing leapers below

	if (devolution != -1 && devolution != -2 && !admintransed)

		if (istype(mutantrace, /datum/mutantrace/xenomorph/drone) && !istype(mutantrace, /datum/mutantrace/xenomorph/drone/queen))
			if (istype(mutantrace, /datum/mutantrace/xenomorph/drone/l))
				whatToRemove = "xdronel"
			else
				whatToRemove = "xdrone"

			if (e != "Sentinel")
				if (!devolution && !admintransed)
					return 0

		else if (istype(mutantrace, /datum/mutantrace/xenomorph/sentinel))
			if (istype(mutantrace, /datum/mutantrace/xenomorph/sentinel/l))
				whatToRemove = "xsentinell"
			else
				whatToRemove = "xsentinel"

			if (e != "Warrior" && e != "Praetorian")
				if (!devolution && !admintransed)
					return 0

		else if (istype(mutantrace, /datum/mutantrace/xenomorph/warrior))
			if (istype(mutantrace, /datum/mutantrace/xenomorph/sentinel/l))
				whatToRemove = "xwarriorl"
			else
				whatToRemove = "xwarrior"
			if (!devolution && !admintransed)
				return 0//no removing warrior

		else if (istype(mutantrace, /datum/mutantrace/xenomorph/praetorian))
			whatToRemove = "xpraetorian"
			if (e != "Queen")
				if (!devolution && !admintransed)
					return 0//no valid evolution

		else if (istype(mutantrace, /datum/mutantrace/xenomorph/drone/queen) && !istype(mutantrace, /datum/mutantrace/xenomorph/drone/queen/empress))
			whatToRemove = "xqueen"
			if (e != "Empress")
				if (!devolution && !admintransed)
					return 0//no valid evolution

		else if (istype(mutantrace, /datum/mutantrace/xenomorph/drone/queen/empress))
			if (!devolution && !admintransed)
				return 0//no removing empress

	if (devolution != -1 && devolution != -2 && !admintransed)
		src.visible_message("<span style=\"color:red\"><B>[src]'s body starts to twist and contort...</B></span>", "<span style=\"color:blue\"><B>You start the evolution. This will take a while.</B></span>")

	var/src_last_loc = src.loc

	if (devolution != -1 && devolution != -2)
		if (!admintransed)
			transforming = 1
			spawn(src:mutantrace:evoTime)//just incase something breaks here
				transforming = 0
			sleep(src:mutantrace:evoTime)
			transforming = 0


	if (src.loc != src_last_loc)
		if (devolution != -1 && devolution != -2 && !admintransed)
			boutput(src, "<span style=\"color:red\"><B>The evolution has failed; you must stand still.</B></span>")
			return 0

	if (admintransed)
		if (istype(src.mutantrace, /datum/mutantrace/xenomorph/drone))
			whatToRemove = "xdrone"//we're going to assume that leaping
			//is not happening since it's terrible and disabled
			if (istype(src.mutantrace, /datum/mutantrace/xenomorph/drone/queen))
				whatToRemove = "xqueen"
				if (istype(src.mutantrace, /datum/mutantrace/xenomorph/drone/queen/empress))
					whatToRemove = "xempress"
		else if (istype(src.mutantrace, /datum/mutantrace/xenomorph/sentinel))
			whatToRemove = "xsentinel"
		else if (istype(src.mutantrace, /datum/mutantrace/xenomorph/warrior))
			whatToRemove = "xwarrior"
		else if (istype(src.mutantrace, /datum/mutantrace/xenomorph/praetorian))
			whatToRemove = "xpraetorian"

	if (bioHolder)
		bioHolder.RemoveEffect(whatToRemove)

	if (transforming || !bioHolder)
		if (transforming)
			boutput(src, "<span style = \"color:red\"><b>You are already transforming.</span></b>")
		return

	unequip_all()

	if (e == "Drone")

		bioHolder.AddEffect("xdrone[devolution == -1 ? "l" : ""]")
		if (devolution != -1 && devolution != -2 && !admintransed)
			src.visible_message("<span style=\"color:red\"><B>[src]'s body contorts, changing into a new, more robust form.</B></span>", "<span style=\"color:blue\"><B>You have evolved into a Drone.</B></span>")

	else if (e == "Sentinel")

		bioHolder.AddEffect("xsentinel[devolution == -1 ? "l" : ""]")
		if (devolution != -1 && devolution != -2 && !admintransed)
			src.visible_message("<span style=\"color:red\"><B>[src]'s body contorts, changing into a new, more robust form.</B></span>", "<span style=\"color:blue\"><B>You have evolved into a Sentinel.</B></span>")

		src.update_alien_light()

	else if (e == "Warrior")

		bioHolder.AddEffect("xwarrior[devolution == -1 ? "l" : ""]")
		if (devolution != -1 && devolution != -2 && !admintransed)
			src.visible_message("<span style=\"color:red\"><B>[src]'s body contorts, changing into a new, more robust form.</B></span>", "<span style=\"color:blue\"><B>You have evolved into a Warrior.</B></span>")

	else if (e == "Praetorian")

		bioHolder.AddEffect("xpraetorian")
		if (devolution != -1 && devolution != -2 && !admintransed)
			src.visible_message("<span style=\"color:red\"><B>[src]'s body contorts, changing into a new, much larger and more robust form.</B></span>", "<span style=\"color:blue\"><B>You have evolved into a Praetorian.</B></span>")

	else if (e == "Queen")

		bioHolder.AddEffect("xqueen")
		if (devolution != -1 && devolution != -2 && !admintransed)
			src.visible_message("<span style=\"color:red\"><B>[src]'s body contorts, changing into a massive, hulking shape.</B></span>", "<span style=\"color:blue\"><B>You have evolved into a Queen.</B></span>")

	else if (e == "Empress")

		bioHolder.AddEffect("xempress")
		if (devolution != -1 && devolution != -2 && !admintransed)
			src.visible_message("<span style=\"color:red\"><B>[src]'s body contorts, changing into a new, more robust and even more massive form.</B></span>", "<span style=\"color:blue\"><B>You have evolved into an Empress.</B></span>")

	update_xeno_abilities()

	if (admintransed)
		boutput(src, "<span style=\"color:red\"><b>You are [e == "Queen" || e == "Empress" ? "the" : "an"] Xenomorph [e]. Your one duty is to [e == "Queen" || e == "Empress" ? "lead the hive to victory, and wipe out the survivors." : "serve the Queen."]</span></b>")
		boutput(src, "<span style=\"color:red\"><b>You can talk to other Xenomorphs using :a.</span></b>")

	if (devolution != -1 && devolution != -2)
		src.full_heal()
		src.updatehealth()
		src.name = get_new_xenomorph_name()
		src.real_name = src.name
	//	src.mutantrace:maxPlasma *= plasma_multiplier //AH FUCK THIS MAKES PLASMA WAY TOO HIGH IF YOU EAT ORGANS AS A LARVA
		src.mutantrace:maxPlasma += plasma_addition

	return 1

/mob/living/carbon/human/proc/xcanleap()

	if (!mutantrace || !istype(mutantrace, /datum/mutantrace/xenomorph))
		return 0

	if (mutantrace:bigXeno)
		return 0

	return 1

/mob/living/carbon/human/proc/xventcrawl()

	if (!mutantrace || !istype(mutantrace, /datum/mutantrace/xenomorph))
		return 0

	if (mutantrace:bigXeno)
		return 0

	return 1

/mob/living/carbon/human/proc/xdevour(var/mob/living/critter/crit)

	if (!mutantrace || !istype(mutantrace, /datum/mutantrace/xenomorph))
		return 0

	return 1

/mob/living/carbon/human/proc/xresinhuman(var/mob/living/carbon/human/h, var/target_area)

	if (!mutantrace || !istype(mutantrace, /datum/mutantrace/xenomorph))
		return 0

	if (istype(h))
		switch (target_area)
			if ("mouth")
				return 1
			if ("eyes")
				return 1
			if ("ears")
				return 1

	return 1

/mob/living/carbon/human/proc/xEvolve_Next(var/chain = "Warrior")

	if (!mutantrace || !istype(mutantrace, /datum/mutantrace/xenomorph))
		return 0

	if (chain == "Warrior")
		if (istype(src, /datum/mutantrace/xenomorph/drone))
			xSetMobEvolution("Sentinel")
		else if (istype(src, /datum/mutantrace/xenomorph/sentinel))
			xSetMobEvolution("Warrior")
		else if (istype(src, /datum/mutantrace/xenomorph/warrior))
			return
			//no siree
	else if (chain == "Queen")
		if (istype(src, /datum/mutantrace/xenomorph/drone))
			xSetMobEvolution("Sentinel")
		else if (istype(src, /datum/mutantrace/xenomorph/sentinel))
			xSetMobEvolution("Praetorian")
		else if (istype(src, /datum/mutantrace/xenomorph/praetorian))
			xSetMobEvolution("Queen")
		else if (istype(src, /datum/mutantrace/xenomorph/drone/queen))
			xSetMobEvolution("Empress")
		else if (istype(src, /datum/mutantrace/xenomorph/drone/queen/empress))
			return

	return 1

/mob/living/carbon/human/proc/xweed_here()

	if (!mutantrace || !istype(mutantrace, /datum/mutantrace/xenomorph/drone))
		return 0

	new/obj/xeno/hive/weeds(loc, 1)

	return 1


/mob/living/carbon/human/proc/xsecrete_resin_here()

	if (!mutantrace || !istype(mutantrace, /datum/mutantrace/xenomorph/drone))
		return 0

	new/obj/xeno/hive/resin_pile(loc)

	return 1

/mob/living/carbon/human/proc/xbuild_resin_here()

	if (!mutantrace || !istype(mutantrace, /datum/mutantrace/xenomorph/drone))
		return 0

	return 1

/mob/living/carbon/human/proc/xlay_egg_here()

	if (!mutantrace || !istype(mutantrace, /datum/mutantrace/xenomorph/drone/queen))
		return 0

	return 1


/mob/living/carbon/human/proc/xcreate_plasma_node()

	if (!mutantrace || !istype(mutantrace, /datum/mutantrace/xenomorph/drone/queen))
		return 0

	return 1
