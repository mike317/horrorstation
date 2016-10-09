

/datum/targetable/xenomorph/evolve
	name = "Evolution"
	desc = "Evolve to a higher caste."
	icon_state = "evo"
	cooldown = 0
	targeted = 0
	target_anything = 0
	restricted_area_check = 2

	cast(atom/target)
		if (..())
			return 1

		var/mob/living/C = holder.owner

		if (C:mutantrace:evoProgress < C:mutantrace:maxEvoProgress)
			boutput(C, "<span style = \"color:red\"><B>You are not ready to evolve.</span></B>")
			return 0

		if (C:mutantrace:maxEvoProgress == -1)
			boutput(C, "<span style = \"color:red\"><B>You cannot evolve beyond this form.</span></B>")
			return 0

		var/evo_list[0]

		if (istype(C:mutantrace, /datum/mutantrace/xenomorph/larva))
			evo_list = list("Drone")

		if (istype(C:mutantrace, /datum/mutantrace/xenomorph/drone) && !istype(C:mutantrace, /datum/mutantrace/xenomorph/drone/queen))
			evo_list = list("Sentinel")//this is so queens override the drone list

		else if (istype(C:mutantrace, /datum/mutantrace/xenomorph/sentinel))
			evo_list = list("Warrior", "Praetorian")

		else if (istype(C:mutantrace, /datum/mutantrace/xenomorph/warrior))
			evo_list.len = 0

		else if (istype(C:mutantrace, /datum/mutantrace/xenomorph/praetorian))
			evo_list = list("Queen")

		else if (istype(C:mutantrace, /datum/mutantrace/xenomorph/drone/queen))
			evo_list.len = 0

		if (!evo_list.len)
			boutput(C, "<span style = \"color:red\"><B>You cannot evolve beyond this form.</span></B>")
			return 0

		var/evoPath

		if (evo_list.len == 2)

			evoPath = alert(C, "Evolve into what?", "", evo_list[1], evo_list[2])

		else if (evo_list.len == 1)

			evoPath = alert(C, "Evolve into what?", "", evo_list[1])

			/*
		var/evoType = "Warrior"

		if (evoPath == "Drone")
			evoType = "Warrior"//type doesn't matter here

		else if (evoPath == "Warrior")
			evoType = "Warrior"//clearly

		else if (evoPath == "Praetorian")
			evoType = "Queen"
			*/

		C:xSetMobEvolution(evoPath, 0)

		return 0
