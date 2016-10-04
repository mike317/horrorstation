/datum/targetable/xenomorph/murder
	name = "Murder"
	desc = "Use your inner mouth to penetrate the skull and instantly kill any living being. They must be incapacitated."

/datum/targetable/xenomorph/rapid_secrete_acid
/datum/targetable/xenomorph/secrete_acid
	name = "Secrete Acid"
	desc = "Secrete acid into various objects, for fun effects. Mostly explosions. This uses the object in front of you, or the floor if there is no object."
	icon_state = "resinp"
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

		if (!locate(/obj/reagent_dispensers) in get_step(C, C.dir) && !locate(/obj/burning_barrel) in get_step(C, C.dir) && !locate(/obj/machinery/light))
			return 0

		if (!istype(C:mutantrace, /datum/mutantrace/xenomorph/sentinel) && !istype(C:mutantrace, /datum/mutantrace/xenomorph/praetorian))
			boutput(C, "<span style = \"color:red\"><B>Your caste cannot secrete acid.</span></B>")
			return 0

		if (C:mutantrace:plasma < 100)
			boutput(C, "<span style = \"color:red\"><B>You need at least 100 plasma to use this ability.</span></B>")
			return 0


		C:mutantrace:plasma-=100

		for (var/obj/reagent_dispensers/r in get_step(C, C.dir))
			r.ex_act(1.0)

		for (var/obj/burning_barrel/b in get_step(C, C.dir))
			b.ex_act(1.0)

		for (var/obj/machinery/light/l in get_step(C, C.dir))
			l.ex_act(1.0)

		return 0
