
/datum/targetable/xenomorph/weed
	name = "Plant Weeds"
	desc = "Plant weeds."
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

		if (!istype(C:mutantrace, /datum/mutantrace/xenomorph/drone))
			boutput(C, "<span style = \"color:red\"><B>Your caste cannot plant weeds.</span></B>")
			return 0

		if (C:mutantrace:plasma < 200)
			boutput(C, "<span style = \"color:red\"><B>You need at least 200 plasma to do this.</span></B>")
			return 0


		boutput(C, "<span style = \"color:blue\"><B>You plant some weeds.</B></span")

		C:mutantrace:plasma -= 200
		new/obj/xeno/hive/weeds(C.loc, 1)
	//	playsound(C.loc, 'vomitsound.ogg', 100, 1)
		return 0
