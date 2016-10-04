/obj/xeno/hive/egg
	desc = "It looks like a weird egg"
	name = "egg"
	icon_state = "egg_growing"
	layer = MOB_LAYER
	density = 0.0
	anchored = 1

	var/health = 25
	var/opening = 0

	New()
		spawn(rand(2000, 25000))
			if (src.health > 0)
				icon_state = "egg"
		spawn(rand(4000,5000))//was at 900, 1.5 mins
			if(src.health > 0)
				src.open()
	examine()
		if (isAlien(usr))
			boutput(usr, "That's an egg. It seems to be [icon_state == "egg_hatched" ? "hatched" : "unhatched"].")
		else
			boutput(usr, "<span class = \"color:red\">A strange, egg-like thing. You have a very bad feeling about it.</span>")

	proc/open()
		if (opening) return
		opening = 1
		src.icon_state = "egg_opening"
		spawn(15)
			src.density = 0.0
			src.icon_state = "egg_hatched"
			new /obj/item/xeno/facehugger(src.loc)
			qdel(src)

	attack_hand(mob/user as mob)
		if (icon_state == "egg")
			open()
		if (icon_state == "egg_hatched")
			if (isAlien(user))
				src.visible_message("<span style=\"color:red\"><B>[user] has cleared the hatched egg.</span></B>")
				qdel(src)

	attackby(obj/item/W as obj, mob/user as mob)
		if (src.health <= 0)
			src.visible_message("<span style=\"color:red\"><B>[user] has destroyed the egg!</B></span>")
			src.death()
			return

		switch(W.damtype)
			if("fire")
				src.health -= W.force * 0.75
			if("brute")
				src.health -= W.force * 0.1
			else
		..()

	death()
		src.icon_state = "egg_hatched"
		src.density = 0