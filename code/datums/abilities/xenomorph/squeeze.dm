mob/living/carbon/human/proc/squeeze(var/turf/location)
	mutantrace:hiding = 1
	layer = HIDING_MOB_LAYER
	spawn(rand(4,6))
		loc = location
		mutantrace:hiding = 0
		layer = initial(layer)

/datum/targetable/xenomorph/squeeze
	name = "Squeeze"
	desc = "Squeeze through a door, or under a table, window, or grille."
	icon_state = "squeezeskill"
	cooldown = 0
	targeted = 0
	target_anything = 0
	restricted_area_check = 2

	cast(atom/target)
		if (..())
			return 1

		var/mob/living/carbon/human/H = holder.owner

		if (!H.loc)
			return 0

		if (!istype(H:mutantrace, /datum/mutantrace/xenomorph/larva/facehugger))
			boutput(H, "<span style = \"color:red\"><B>Only facehuggers can use this skill. How did you even get here?</span></B>")
			return 0

		for (var/obj/o in get_step(H, H.dir))
			if (istype(o, /obj/grille) || istype(o, /obj/window) || istype(o, /obj/machinery/door) || istype(o, /obj/table) || istype(o, /obj/plasticflaps))
				if (locate(/turf/space) in range(1, o))
					return//no squeezing into space now

		for (var/obj/grille/g in get_step(H, H.dir))
			if (!g.density)
				continue
			for (var/obj/o in g.loc)
				if (!istype(o, /obj/window) && o.density && o != g)
					return

			H.squeeze(g.loc)
			H.visible_message("<span style = \"color:red\">[H] squeezes under the grille.</span>","<span style = \"color:red\">You squeeze under the grille.</span>")
			break

		for (var/obj/window/w in get_step(H, H.dir))
			if (!w.density)
				continue
			for (var/obj/o in w.loc)
				if (!istype(o, /obj/grille) && o.density && o != w)
					return

			H.squeeze(w.loc)
			H.visible_message("<span style = \"color:red\">[H] squeezes under the window.</span>","<span style = \"color:red\">You squeeze under the window.</span>")
			break

		for (var/obj/table/t in get_step(H, H.dir))
			if (!t.density)
				continue

			H.squeeze(t.loc)
			H.visible_message("<span style = \"color:red\">[H] squeezes under the table.</span>","<span style = \"color:red\">You squeeze under the table.</span>")
			break

		for (var/obj/plasticflaps/p in get_step(H, H.dir))
			if (!p.density)
				continue

			for (var/obj/o in p.loc)
				if (o.density && o != p)
					return

			H.squeeze(p.loc)
			H.visible_message("<span style = \"color:red\">[H] squeezes through the plastic flaps.</span>","<span style = \"color:red\">You squeeze through the plastic flaps.</span>")
			break

		for (var/obj/machinery/door/d in get_step(H, H.dir))
			if (!d.density)
				continue

			for (var/obj/o in d.loc)
				if (o.density && o != d)
					return

			if (!istype(d, /obj/machinery/door/poddoor))
				H.squeeze(d.loc)
				H.visible_message("<span style = \"color:red\">[H] squeezes through the door.</span>","<span style = \"color:red\">You squeeze through the door.</span>")

		return 0