/obj/xeno/hive
	icon = 'icons/tg-goon-xenos/xeno.dmi'
	anchored = 1.0

	ex_act(severity)
		switch(severity)
			if(1.0)
				qdel(src)
				return
			if(2.0)
				if (prob(50))
					qdel(src)
					return
			if(3.0)
				if (prob(25))
					qdel(src)
					return
			else
		return

	proc/death()
		src.visible_message("<span style=\"color:red\"><B>[src] collapses into a pile of resin goop.</B></span>")
		qdel(src)
		return 1

	wall
		icon_state = "wall0"

		var/health = 25

		density = 1.0

		opacity = 1.0

		attack_hand(mob/user as mob)
			if (isAlien(user) && !user.buckled)
				if (user.a_intent != "harm")
					return 0
				src.visible_message("<span style=\"color:red\"><B>[user] slashes at the wall.</B></span>")
				playsound(loc, 'sound/weapons/slashcut.ogg', 100, 1)
				if (prob(20 + user:mutantrace:get_object_destroy_bonus_chance()))
					src.death()
					return 1

		attackby(obj/item/W as obj, mob/user as mob)
			if (src.health <= 0)
				src.visible_message("<span style=\"color:red\"><B>[user] has destroyed the resin wall.</B></span>")
				del src
				return

			switch(W.damtype)
				if("fire")
					src.health -= W.force * 3
				if("brute")
					src.health -= W.force * 2
				else
					src.health -= W.force
			..()
		examine()
			if (isAlien(usr))
				boutput(usr, "That's a membrane. It seems to have [health]/[initial(health)] health.")
			else
				boutput(usr, "<span class = \"color:red\">A strange resin structure.</span>")
	membrane
		icon_state = "membrane0"

		var/health = 20

		density = 1.0

		attack_hand(mob/user as mob)
			if (isAlien(user) && !user.buckled)
				if (user.a_intent != "harm")
					return 0
				src.visible_message("<span style=\"color:red\"><B>[user] slashes at the mebrane.</B></span>")
				playsound(loc, 'sound/weapons/slashcut.ogg', 100, 1)
				if (prob(40 + user:mutantrace:get_object_destroy_bonus_chance()))
					src.death()
					return 1

		attackby(obj/item/W as obj, mob/user as mob)
			if (src.health <= 0)
				src.visible_message("<span style=\"color:red\"><B>[user] has destroyed the resin membrane.</B></span>")
				del src
				return

			switch(W.damtype)
				if("fire")
					src.health -= W.force * 3
				if("brute")
					src.health -= W.force * 2
				else
					src.health -= W.force
			..()
		examine()
			if (isAlien(usr))
				boutput(usr, "That's a membrane. It seems to have [health]/[initial(health)] health.")
			else
				boutput(usr, "<span class = \"color:red\">A strange, transparent resin structure.</span>")
	nest
		icon_state = "nest"
		name = "Nest"
		desc = "a strange resin nest."
		icon = 'icons/tg-goon-xenos/xeno.dmi'
		icon_state = "nest"

		var/health = 10
		density = 0.0

		MouseDrop_T(mob/living/carbon/human/M as mob, mob/user as mob)
			if (!M.lying)
				boutput(user, "<span style=\"color:red\">The target must be weakened first.</span>")
				return 0
			if (!ishuman(M))
				return 0
			if (ismonkey(M))
				return 0
			if (!isAlien(user))
				return 0
			if (!ticker)
				boutput(user, "You can't buckle anyone in before the game starts.")
				return
			if ((get_dist(src, user) > 1 || get_dist(M, user) > 1 || user.restrained() || user.stat))
				return
			for(var/mob/O in viewers(user, null))
				if ((O.client && !( O.blinded )))
					boutput(O, text("<span style=\"color:blue\">[M] is strapped into the nest by [user]!</span>"))
					boutput(M, text("<span style=\"color:red\">You are strapped into the nest by [user].</span>"))
			M.anchored = 1
			M.lying = 1
			M.buckled = src
			M.set_loc(src.loc)
			if (ishuman(M))
				var/mob/living/carbon/human/H = M
				H.update_clothing()
			src.add_fingerprint(user)
			return

		attack_hand(mob/user as mob)
			if (isAlien(user) && !user.buckled)
				if (user.a_intent != "harm")
					if (isAlien(user))
						for(var/mob/M in src.loc)
							if (M.buckled)
								src.visible_message("<span style=\"color:blue\">[M] is released from the nest by [user].</span>")
					//			boutput(world, "[M] is no longer buckled to [src]")
								M.anchored = 0
								M.buckled = null
								if (ishuman(M))
									var/mob/living/carbon/human/H = M
									H.update_clothing()

					return 1



				src.visible_message("<span style=\"color:red\"><B>[user] slashes at the nest.</B></span>")
				playsound(loc, 'sound/weapons/slashcut.ogg', 100, 1)
				if (prob(30 + user:mutantrace:get_object_destroy_bonus_chance()))
					for(var/mob/M in src.loc)
						if (M.buckled)
							src.visible_message("<span style=\"color:blue\">[M] is freed from the nest.</span>")
				//			boutput(world, "[M] is no longer buckled to [src]")
							M.anchored = 0
							M.buckled = null
							if (ishuman(M))
								var/mob/living/carbon/human/H = M
								H.update_clothing()
					src.death()
					return 1
			return

		attackby(obj/item/W as obj, mob/user as mob)


			switch(W.damtype)
				if("fire")
					src.health -= W.force * 3
				if("brute")
					src.health -= W.force * 2
				else
					src.health -= W.force
			..()

			if (src.health <= 0)
				src.visible_message("<span style=\"color:red\"><B>[user] has destroyed the nest.</B></span>")
				for(var/mob/M in src.loc)
					if (M.buckled)
						src.visible_message("<span style=\"color:blue\">[M] is freed from the nest.</span>")
			//			boutput(world, "[M] is no longer buckled to [src]")
						M.anchored = 0
						M.buckled = null
				src.death()
				return
		examine()
			if (isAlien(usr))
				boutput(usr, "That's a nest, used for securing hosts.")
			else
				boutput(usr, "<span class = \"color:red\">A strange construction of resin.</span>")

	plasma_pool
		density = 0.0

		icon_state = ""

	resin_pile
		var/uses = 10

		density = 0.0

		New()
			..()
			uses = rand(5,10)

		icon_state = "chitin"
		attack_hand(mob/user)
			if (isAlien(user))

				user.put_in_hand_or_drop(new/obj/item/xeno/resin)
				uses--

				if (!uses || uses < 0)
					qdel(src)

				return 1

		attackby(obj/item/xeno/resin/W as obj, mob/user as mob)
			if (istype(W, /obj/item/xeno/resin))
				if (isAlien(user))
					W.stacked++
					boutput(user, "<span style = \"color:red\">You add some resin to the piece in your hand. You are now carrying [W.stacked] pieces.</span>")
					uses--
					if (!uses || uses < 0)
						qdel(src)
					return 1

				return 0

		examine()
			if (isAlien(usr))
				boutput(usr, "That's a pile of resin goop, used for hive construction.")
			else
				boutput(usr, "<span class = \"color:red\">A strange pile of resin goop.</span>")