/mob/living/carbon/human/var/building_structure = 0

/obj/item/woodstuff/plank
	name = "wooden plank"
	desc = "My best friend plank!"
	icon = 'icons/obj/hydroponics/hydromisc.dmi'
	icon_state = "plank"
	force = 4.0
		//cogwerks - burn vars
	burn_point = 400
	burn_output = 1500
	burn_possible = 1
	health = 50
	//
	stamina_damage = 40
	stamina_cost = 40
	stamina_crit_chance = 10

	attack_self()
		if (!ishuman(usr) || usr:building_structure)
			return

		var/mob/living/carbon/human/humie

		if (ishuman(usr))
			humie = usr
		else
			return

		humie.building_structure = 1

		boutput(usr, "<span style=\"color:blue\">Now building wood wall. You'll need to stand still.</span>")
		var/turf/T = get_turf(usr)
		sleep(30)
		if(usr.loc == T)
			if(!locate(/obj/structure/woodwall) in T)
				var/obj/structure/woodwall/N = new /obj/structure/woodwall(T)
				N.builtby = usr.real_name
				src.unequipped(usr)
				qdel(src)
				humie.building_structure = 0
				for (var/mob/m in view(N))
					N.sawbuilt.Add(m)
			else
				boutput(usr, "<span style=\"color:red\">There's already a barricade here!</span>")
				humie.building_structure = 0
		else
			humie.building_structure = 0
			return

		if (humie.building_structure == 1)
			humie.building_structure = 0

/obj/item/woodstuff/woodclutter
	name = "wooden clutter"
	icon = 'icons/misc/exploration.dmi'
	icon_state = "woodclutter4"
	force = 4.0
		//cogwerks - burn vars
	burn_point = 400
	burn_output = 1500
	burn_possible = 1
	health = 50
	//
	stamina_damage = 40
	stamina_cost = 40
	stamina_crit_chance = 10

	attack_self()
		if (!ishuman(usr) || usr:building_structure)
			return

		var/mob/living/carbon/human/humie

		if (ishuman(usr))
			humie = usr
		else
			return

		boutput(usr, "<span style=\"color:blue\">Now building wood wall. You'll need to stand still.</span>")
		var/turf/T = get_turf(usr)
		humie.building_structure = 1
		sleep(30)
		if(usr.loc == T)
			if(!locate(/obj/structure/woodwall) in T)
				var/obj/structure/woodwall/N = new /obj/structure/woodwall(T)
				N.builtby = usr.real_name
				src.unequipped(usr)
				qdel(src)
				humie.building_structure = 0
				for (var/mob/m in view(N))
					N.sawbuilt.Add(m)
			else
				boutput(usr, "<span style=\"color:red\">There's already a barricade here!</span>")
				humie.building_structure = 0
		else
			humie.building_structure = 0
			return

		if (humie.building_structure == 1)
			humie.building_structure = 0