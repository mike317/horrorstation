

/datum/targetable/xenomorph/hide
	name = "Hide"
	desc = "Hide under any object."
	icon = 'icons/tg-goon-xenos/xeno.dmi'
	icon_state = "hideskill"
	cooldown = 0
	targeted = 0
	target_anything = 0
	restricted_area_check = 2

	cast(atom/target)
		if (..())
			return 1

		var/mob/living/carbon/human/H = holder.owner

		if (!istype(H:mutantrace, /datum/mutantrace/xenomorph/larva))//huggers are descendents of larvae
			boutput(H, "<span style = \"color:red\"><B>Your caste cannot hide. How did you even get here?</span></B>")
			return 0


		var/datum/mutantrace/xenomorph/larva/l = H.mutantrace
		l.hiding = !l.hiding
		boutput(H, "<span style = \"color:red\"><b>You are [l.hiding ? "now hiding" : "no longer hiding"].</span></b>")

		if (l.hiding)
			H.layer = HIDING_MOB_LAYER
		else
			H.layer = initial(H.layer)

		return 0

