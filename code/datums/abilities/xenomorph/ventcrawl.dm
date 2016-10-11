proc
	text2list(string, delimiter=" ")
		var/list/listified = new, last=1
		for(var/find=findtext(string, delimiter); find; find=findtext(string, delimiter, find+length(delimiter)))
			listified += copytext(string, last, find)
			last=find+length(delimiter)

		listified += copytext(string, last)

		return listified


/datum/targetable/xenomorph/vent_crawl
	name = "Vent Crawl"
	desc = "Crawl from one vent on the station to another."
	icon_state = "vent"
	cooldown = 0
	targeted = 0
	target_anything = 0
	restricted_area_check = 2

	cast(atom/target)
		if (..())
			return 1

		var/mob/living/C = holder.owner

		if (!locate(/obj/machinery/atmospherics/unary/vent_pump) in C.loc)
			return 0

		if (!C:xventcrawl())
			return 0
			/*
		if (istype(T.mutantrace, /datum/mutantrace/monkey))
			boutput(C, "<span style=\"color:red\">Our hunger will not be satisfied by this lesser being.</span>")
			return 1
			*/
			/*
		if (T.bioHolder.HasEffect("husk"))
			boutput(usr, "<span style=\"color:red\">This creature has already been drained...</span>")
			return 1
			*/


		if (!vents || !vents.len)
			vents = new/list()

			for (var/obj/machinery/atmospherics/unary/vent_pump/vp in world)
				vents += vp

			for (var/obj/machinery/atmospherics/binary/dp_vent_pump/vp in world)
				vents += vp

			for (var/obj/machinery/atmospherics/pipe/vent/v in world)
				vents += v

		var/vent_list_names[0]

		var/vent_num_for_this_area = 1

		for (var/v in vents)

			for (var/ventnum = 1, ventnum <= 20, ventnum++)
				if (vent_list_names.Find("[v:loc:loc ? v:loc:loc : ""][v:loc:loc ? " " : ""]Vent #[ventnum]"))
					vent_num_for_this_area = ventnum+1
					break
				else
					vent_num_for_this_area = ventnum
					break

			if (v:loc:loc.name && !findtext(v:loc:loc.name, "somewhere") && !findtext(v:loc:loc.name, "Somewhere"))
				vent_list_names += "[v:loc:loc ? v:loc:loc : ""][v:loc:loc ? " " : ""]Vent #[vent_num_for_this_area]"

		var/C_loc = C.loc

		var/vent = input(C, "Which vent do you want to crawl to?") in vent_list_names

		//at this point, each vent in vents should correspond with a vent in the
		//same department in vent_list_names

	//	var/splitvent = text2list(vent, "#")

	//	var/ventp1 = vents[text2num(splitvent[1])]//originally it was just realvent
										// = vents[text2num(splitvent[2])], which
											//made a total of 2 vents accessable
	//	var/ventp2 = vents[text2num(splitvent[2])]


		var/pos = 1
		var/finalpos = 1
		for (var/v in vent_list_names)
			if (v == vent)
				finalpos = pos
				break
			pos++

		var/realvent = vents[finalpos]

		if (realvent && istype(realvent, /obj/machinery/atmospherics))

			var/crawldelay = 0
			if (!isTrueAlien(C))
				if (isAlienLarva(C))
					crawldelay = 5
				if (isAlienHugger(C))
					crawldelay = 2
			else
				crawldelay = rand(7,9)
				if (isAlienWarrior(C))
					crawldelay = rand(2,3)

			if (C.loc != C_loc)
				return

			boutput(C, "<span style = \"color:red\">You start crawling through the vents...</span>")

			spawn(crawldelay)
				C.visible_message("<span style = \"color:red\"><b>[C] crawls through the vents!</b></span>", "<span style = \"color:blue\">You crawl through the vents.</span>")

				C.loc = get_turf(realvent)

		return 0
