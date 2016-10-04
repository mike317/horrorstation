//copied from cocoon.dm

/obj/xeno/hive/nest
	name = "nest"
	desc = "a strange... something..."
	density = 0.0
	anchored = 1.0
	icon = 'icons/obj/objects.dmi'
	icon_state = "toilet"

	var/health = 10

	MouseDrop_T(mob/M as mob, mob/user as mob)
		if (!ticker)
			boutput(user, "You can't buckle anyone in before the game starts.")
			return
		if ((!( istype(M, /mob) ) || get_dist(src, user) > 1 || user.restrained() || usr.stat))
			return
		for(var/mob/O in viewers(user, null))
			if ((O.client && !( O.blinded )))
				boutput(O, text("<span style=\"color:blue\">[M] is absorbed by the cocoon!</span>"))
		M.anchored = 1
		M.buckled = src
		M.set_loc(src.loc)
		src.add_fingerprint(user)
		return

	attack_hand(mob/user as mob)
		if(health <= 0)
			for(var/mob/M in src.loc)
				if (M.buckled)
					src.visible_message("<span style=\"color:blue\">[M] appears from the cocoon.</span>")
		//			boutput(world, "[M] is no longer buckled to [src]")
					M.anchored = 0
					M.buckled = null
					src.add_fingerprint(user)
		return

	attackby(obj/item/W as obj, mob/user as mob)
		if (src.health <= 0)
			src.visible_message("<span style=\"color:red\"><B>[user] has destroyed the cocoon.</B></span>")
			src.death()
			return

		switch(W.damtype)
			if("fire")
				src.health -= W.force * 0.75
			if("brute")
				src.health -= W.force * 0.1
			else
		..()

	proc/death()
		src.icon_state = "egg_destroyed"	//need an icon for this
		src.density = 0