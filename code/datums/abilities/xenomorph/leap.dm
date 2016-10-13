
/datum/targetable/xenomorph/leap_toggle
	name = "Leap"
	desc = "Toggle or detoggle leaping. This uses stamina."
	icon_state = "leap"
	cooldown = 0
	targeted = 0
	target_anything = 0
	restricted_area_check = 2

	cast(atom/target)
		if (..())
			return 1

		var/mob/living/C = holder.owner

		if (!C:xcanleap())
			return 0

		C:mutantrace:leaping = !C:mutantrace:leaping

		boutput(C, "<span class='game xeno'>You are [C:mutantrace:leaping ? "now" : "no longer"] leaping.</span>")

		if (C:mutantrace:leaping)
			C:mutantrace:leap()
		else
			C:mutantrace:stop_leaping()

		return 0
