
/datum/targetable/xenomorph/weed
	name = "Plant Weeds"
	desc = "Plant some weeds, which are necessary to expand the hive."
	icon_state = "weednode"
	cooldown = 0
	targeted = 0
	target_anything = 0
	restricted_area_check = 2

	cast(atom/target)
		if (..())
			return 1

		var/mob/living/C = holder.owner

		if (!C.loc || !istype(C.loc, /turf/simulated/floor))
			return 0

		if (!istype(C:mutantrace, /datum/mutantrace/xenomorph/drone) && !istype(C:mutantrace, /datum/mutantrace/xenomorph/praetorian))
			boutput(C, "<span style = \"color:red\"><B>Your caste cannot plant weeds.</span></B>")
			return 0

		if (isAlienDrone(C) && C:mutantrace:plasma < 200 || isAlienPraetorian(C) && C:mutantrace:plasma < 100)
			var/plasma_needed = isAlienDrone(C) ? 200 : 100
			boutput(C, "<span class='game xenobold'>You need at least [plasma_needed] plasma to plant weeds.</span>")
			return 0


		boutput(C, "<span class='game xenobold'>You plant some weeds.</span")

		C:mutantrace:plasma -= isAlienDrone(C) ? 200 : 100
		new/obj/xeno/hive/weeds(C.loc, 1)
		playsound(C.loc, 'sound/effects/splat.ogg', 100, 1)
		return 0
