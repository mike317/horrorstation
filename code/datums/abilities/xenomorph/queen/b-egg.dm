

/datum/targetable/xenomorph/build_egg
	name = "Lay Egg"
	desc = "Lay an egg to grow the next generation of facehuggers."
	icon_state = "egg"
	cooldown = 0
	targeted = 0
	target_anything = 0
	restricted_area_check = 2

	cast(atom/target)
		if (..())
			return 1

		var/mob/living/C = holder.owner

		if (!istype(C:mutantrace, /datum/mutantrace/xenomorph/drone/queen))
			boutput(C, "<span style = \"color:red\"><B>Only Queens can use this ability. How did you even get here, cuck?</span></B>")
			return 0

		if (locate(/obj/xeno/hive/egg) in C.loc)
			boutput(C, "<span style = \"color:red\"><B>There is already an egg here.</span></B>")
			return 0

		if (C:mutantrace:plasma < 100)
			boutput(C, "<span style = \"color:red\"><B>You do not have enough plasma to use this ability.</span></B>")
			return 0

		boutput(C, "<span style = \"color:green\"><B>You lay an egg.</span></B>")

		C:mutantrace:plasma -= 100
		new/obj/xeno/hive/egg(C.loc)

		return 0
