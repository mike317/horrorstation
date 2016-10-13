/mob/living/carbon/human/var/xblowingup = 0//0 = not blowing up, 1 to 2 = getting ready to blow up, 2 = blowing the fuck up

/mob/living/carbon/human/proc/find_xeno_target(var/allow_lying = 0, var/allow_targets = 1, var/AOE = 0)
	var/turf/T = get_step(src, src.dir)//allow_lying, at 2, forces lying.
	var/turf/T2 = src.loc


	var/mob/list/nearby_mobs[0]
/*
	for (var/mob/living/l in T)
		if (l.grabbed_by.Find(src))
			nearby_mobs += l

	for (var/mob/living/l in T2)
		if (l.grabbed_by.Find(src))
			nearby_mobs += l


	*/
	for (var/mob/living/l in range(1, src))//first priority - grabbed mobs
		if (isAlien(l) || l == src)
			continue
		if (l.grabbed_by.Find(src) || src.pulling == l)
			nearby_mobs += l

	for (var/mob/living/l in T)//second priority - mobs right in front of you
		if (isAlien(l) || l == src)
			continue
		if (!allow_lying && !lying || allow_lying && lying)
			nearby_mobs += l

	if (AOE)//third priority - AOE attacks
		nearby_mobs.len = 0
		for (var/mob/living/l in range(AOE, src))
			if (isAlien(l))
				continue
			if (l == src)
				continue
			nearby_mobs += l

	if (!nearby_mobs.len)//fourth priority - mobs on the same turf as you

		for (var/mob/living/l in T2)

			if (isAlien(l))
				continue
			if (l == src)
				continue
			if (!l.lying && allow_lying == 2)
				continue
			if (l.lying && allow_lying)
				nearby_mobs += l
				continue
			if (!lying && allow_lying != 2)
				nearby_mobs += l
				continue





	if (nearby_mobs.len)
		if (allow_targets < 2)
			return pick(nearby_mobs)
		else
			if (nearby_mobs.len > 1)
				if (allow_targets == 2)
					return list(nearby_mobs[1], nearby_mobs[2])
				else
					return nearby_mobs//anything over 2 is all of them fttb
			else
				return list(nearby_mobs[1])//since whatever called the proc is probably expecting a list
	else
		return null

/datum/targetable/xenomorph/rend
	name = "Rend"
	desc = "Severely wound a host by rending them with your teeth. This causes extreme bleeding."
	cooldown = 50
	targeted = 0
	target_anything = 0
	restricted_area_check = 2


	cast(atom/target)
		if (..())
			return 1

		var/mob/living/carbon/human/H = holder.owner

		if (!istype(H))
			return

		if (!H.mutantrace)
			return

		if (!isTrueAlien(H))
			boutput(H, "Only True Xenomorphs can use this ability. What the fuck are you doing here? Get out.")
			return

		if (H.mutantrace:plasma < 150)
			boutput(H, "<span class='game xenobold'>You require at least 150 plasma to use this ability.</span>")
			return
		else
			H.mutantrace:plasma -= 150


		var/mob/living/l = H.find_xeno_target(1)


		if (l)
			l.visible_message("<span class='game xenobold'>[H] brutally rends [l] with their sharp teeth!</span>")
			l.TakeDamage("chest", 50, 0, 0, DAMAGE_CUT)
			playsound(l.loc, 'sound/weapons/slashcut.ogg', 100, 1)



/datum/targetable/xenomorph/penetrate
	name = "Skull Penetration"
	desc = "Use your inner mouth to penetrate the skull and instantly kill any living being. They must be incapacitated."
	cooldown = 100
	targeted = 0
	target_anything = 0
	restricted_area_check = 2

	cast(atom/target)
		if (..())
			return 1

		var/mob/living/carbon/human/H = holder.owner

		if (!istype(H))
			return

		if (!H.mutantrace)
			return

		if (!istype(H.mutantrace, /datum/mutantrace/xenomorph/warrior))
			boutput(H, "Only Warriors can use this ability. What the fuck are you doing here? Get out.")
			return

		if (H.mutantrace:plasma < 150)
			boutput(H, "<span class='game xenobold'>You require at least 150 plasma to use this ability.</span>")
			return
		else
			H.mutantrace:plasma -= 150


		var/mob/living/list/l = H.find_xeno_target(1, 2)

		var/mob/living/first
		var/mob/living/second

		if (l.len > 1)
			first = l[1]
			second = l[2]
		else
			if (l.len)
				first = l[1]
			else
				first = null


		if (first)
			H.visible_message("<span style = \"color:red\">[H] grabs [first], bringing their head up to its mouth...</span>", "<span style = \"color:red\">You grab [first], bringing its head up to your mouth...</span>")
			var/l_loc = l.loc
			var/H_loc = H.loc
			spawn (rand(10,15))
				if (H.loc == H_loc && l.loc == l_loc)
					first.visible_message("<span style = \"color:red\"><big>[H] sends its inner mouth directly through [first]'s head!</span></b>", "<span class='game xenobold'>You end the host's life.</span>")
					first.TakeDamageAccountArmor("head", 10000)//rip
					playsound(first.loc, 'sound/weapons/slashcut.ogg', 100, 1)
					if (second && prob(50))
						second.visible_message("<span style = \"color:red\"><big>[H] sends its inner mouth directly through [second]'s head!</span></b>", "<span class='game xenobold'>You end another host's life, who foolishly stood on the same spot as the first.</span>")
						second.TakeDamageAccountArmor("head", 10000)//rip
						playsound(second.loc, 'sound/weapons/slashcut.ogg', 100, 1)


/datum/targetable/xenomorph/rip_apart
	name = "Rip Apart"
	desc = "Rip apart a host, almost instantly gibbing them."
	cooldown = 20
	targeted = 0
	target_anything = 0
	restricted_area_check = 2

	cast(atom/target)
		if (..())
			return 1

		var/mob/living/carbon/human/H = holder.owner

		if (!istype(H))
			return

		if (!H.mutantrace)
			return

		if (!istype(H.mutantrace, /datum/mutantrace/xenomorph/praetorian))
			boutput(H, "Only Praetorians can use this ability. What the fuck are you doing here? Get out.")
			return

		if (H.mutantrace:plasma < 200)
			boutput(H, "<span class='game xenobold'>You require at least 200 plasma to use this ability.</span>")
			return
		else
			H.mutantrace:plasma -= 200

		var/mob/living/l = H.find_xeno_target(1)

		if (l)
			H.visible_message("<span style = \"color:red\"><big><b>[H] grabs [l], lifting them into the air..</span></big></b>", "<span style = \"color:red\">You grab [l], lifting them into the air..</span>")
			var/l_loc = l.loc
			var/H_loc = H.loc
			var/delay = rand(15,20)
			if (l.lying)
				delay /= 2
			spawn (delay)
				if (H.loc == H_loc && l.loc == l_loc)
					l.visible_message("<span style = \"color:red\"><big><b>[H] rips [l] apart!</b></span></big>")
					l.gib()

/datum/targetable/xenomorph/spit
	name = "Spit"
	desc = "Spit neurotoxin at a host to weaken, but not harm them."
	icon_state = "acidspit"
	cooldown = 5
	targeted = 0
	target_anything = 0
	restricted_area_check = 2

	cast(atom/target)
		if (..())
			return 1


		var/mob/living/carbon/human/H = holder.owner

		if (!istype(H))
			return

		if (!H.mutantrace)
			return

		if (!istype(H.mutantrace, /datum/mutantrace/xenomorph/praetorian) && !istype(H.mutantrace, /datum/mutantrace/xenomorph/sentinel))
			boutput(H, "Only Praetorians/Sentinels can use this ability. What the fuck are you doing here? Get out.")
			return

		if (H.mutantrace:plasma < 50)
			boutput(H, "<span class='game xenobold'>You require at least 50 plasma to use this ability.</span>")
			return
		else
			H.mutantrace:plasma -= 50
/*
		var/mob/living/targ = null

		for (var/mob/living/m in range(10, H))
			if (m.lying)
				continue

			if (m.y > H.y && m.x == H.x && H.dir == NORTH)
				targ = m
				break
			else if (m.y < H.y && m.x == H.x && H.dir == SOUTH)
				targ = m
				break
			else if (m.x > H.x && m.y == H.y && H.dir == EAST)
				targ = m
				break
			else if (m.x < H.x && m.y == H.y && H.dir == WEST)
				targ = m
				break

		if (!targ)
			boutput(H, "You must be facing a target at which to shoot.")
			return
			*/

		var/datum/projectile/energy_bolt/neurotoxin/n = new/datum/projectile/energy_bolt/neurotoxin()

		/*var/obj/projectile/P = */
		shoot_projectile_ST_pixel_spread(H, n, get_step(H, H.dir), 0, 0, 0)
		//if (P)
		//	alter_projectile(P)
		//	P.forensic_ID = src.forensic_ID

/datum/targetable/xenomorph/slam
	name = "Slam"
	desc = "Leverage your body weight against a host or object to send it flying. This will destroy almost all immobile objects."
	cooldown = 10
	targeted = 0
	target_anything = 0
	restricted_area_check = 2


	cast(atom/target)
		if (..())
			return 1

		var/mob/living/carbon/human/H = holder.owner

		if (!istype(H))
			return

		if (!H.mutantrace)
			return

		if (!istype(H.mutantrace, /datum/mutantrace/xenomorph/praetorian))
			boutput(H, "Only Praetorians can use this ability. What the fuck are you doing here? Get out.")
			return

		if (H.mutantrace:plasma < 100)
			boutput(H, "<span class='game xenobold'>You don't have enough plasma to use this ability.</span>")
			return

		H.mutantrace:plasma -= 100

		var/mob/living/l = H.find_xeno_target(0)

		if (l)
			H.visible_message("<span style = \"color:red\"><big><b>[H] slams its massive body into [l]!</span></big></b>", "<span style = \"color:red\"><big><b>You slam your massive body into [l]!</span></big></b>")
			playsound(H.loc, 'sound/effects/bang.ogg', 100, 1)
			l.TakeDamage("All", 50)
			l.weakened += 10
			l.stunned += 10

			step_away(l, H)

			if (prob(80))
				step_away(l, H)
			if (prob(70))
				step_away(l, H)

			return

		for (var/atom/movable/a in get_step(H, H.dir))
			if (a.anchored && a.density && !istype(a, /obj/overlay))
				H.visible_message("<span style = \"color:red\"><b>[H] slams its massive body into [a], crushing it into pieces!</span></b>")
				playsound(H.loc, 'sound/effects/bang.ogg', 100, 1)
				a.ex_act(1.0)
				spawn (1)
					if (a)
						qdel(a)
				return
			else
				if (!ismob(a))
					H.visible_message("<span style = \"color:red\"><b>[H] slams its massive body into [a], knocking it away!</span></b>")
					playsound(H.loc, 'sound/effects/bang.ogg', 100, 1)
					step_away(a, H)
					if (prob(80))
						step_away(a, H)
					if (prob(70))
						step_away(a, H)

					a.ex_act(3.0)
					return


/datum/targetable/xenomorph/tailwhip
	name = "Tail Whip"
	desc = "Whip your tail across the floor, and knock down hosts within a 2x2 radius."
	cooldown = 75
	targeted = 0
	target_anything = 0
	restricted_area_check = 2
	cast(atom/target)
		if (..())
			return 1

		var/mob/living/carbon/human/H = holder.owner

		if (!istype(H))
			return

		if (!H.mutantrace)
			return

		if (!istype(H.mutantrace, /datum/mutantrace/xenomorph/praetorian))
			boutput(H, "Only Praetorians can use this ability. What the fuck are you doing here? Get out.")
			return

		if (H.mutantrace:plasma < 100)
			boutput(H, "<span class='game xenobold'>You don't have enough plasma to use this ability.</span>")
			return

		H.mutantrace:plasma -= 100

		H.visible_message("<span style = \"color:red\"><b>[H] sweeps its long tail across the floor!</span></b>")

		var/mob/living/list/l = H.find_xeno_target(0, 10, rand(2,3))//must be lying, up to 10 target, AOE range of 2 to 3

		for (var/mob/living/somemob in l)

			somemob.visible_message("<span style = \"color:red\"><b>[somemob] is hit by [H]'s tail!</span></b>")
			somemob.remove_stamina(2)
			somemob.weakened += 3
			somemob.TakeDamage("All", rand(10,20), 0, 0, DAMAGE_BLUNT)
			playsound(somemob.loc, 'sound/weapons/slashcut.ogg', 100, 1)
			somemob.emote("scream")


/datum/targetable/xenomorph/tailimpale
	name = "Impale"
	desc = "Impale a host with your tail."
	cooldown = 50
	targeted = 0
	target_anything = 0
	restricted_area_check = 2
	cast(atom/target)
		if (..())
			return 1

		var/mob/living/carbon/human/H = holder.owner

		if (!istype(H))
			return

		if (!H.mutantrace)
			return

		if (!istype(H.mutantrace, /datum/mutantrace/xenomorph/warrior))
			boutput(H, "Only Warriors can use this ability. What the fuck are you doing here? Get out.")
			return

		if (H.mutantrace:plasma < 100)
			boutput(H, "<span class='game xenobold'>You don't have enough plasma to use this ability.</span>")
			return

		H.mutantrace:plasma -= 100


		var/mob/living/list/l = H.find_xeno_target(1, 2)

		var/mob/living/first
		var/mob/living/second

		if (l.len > 1)
			first = l[1]
			second = l[2]

		else
			if (l.len)
				first = l[1]
				second = null
			else
				first = null
				second = null

		var/impale_second = 0


		if (first)
			if (prob(60) && !first.weakened)
				first.visible_message("<span style = \"color:red\">[first] narrowly dodges [H]'s tail attack!</span>")
			else

				H.visible_message("<span style = \"color:red\"><b>[H] sends its tail right through [first]'s stomach!</span></b>")

				playsound(H.loc, 'sound/effects/bloody_stab.ogg', 100, 1)

				first.TakeDamage("chest", rand(100,200), 0, 0, DAMAGE_STAB)
				impale_second = prob(80)

		if (second && impale_second)
			playsound(H.loc, 'sound/effects/bloody_stab.ogg', 100, 1)
			H.visible_message("<span style = \"color:red\"><b>[H]'s tail goes through [first]'s stomach and impales [second] too!</span></b>")
			second.TakeDamage("chest", rand(50,100), 0, 0, DAMAGE_STAB)

		for (var/mob/m in range(1, first))//vertical double-stab
			if (m.x == first.x)
				if (m.y == first.y - 1 && H.y > first.y || m.y == first.y + 1 && H.y < first.y)
					if (prob(25))
						playsound(H.loc, 'sound/effects/bloody_stab.ogg', 100, 1)
						H.visible_message("<span style = \"color:red\"><b>[H]'s tail goes through [first]'s stomach and impales [m] too!</span></b>")
						m.TakeDamage("chest", rand(50,100), 0, 0, DAMAGE_STAB)

		for (var/mob/m in range(1, first))//horizontal double-stab
			if (m.x == first.x)
				if (m.x == first.x - 1 && H.x > first.x || m.x == first.x + 1 && H.x < first.x)
					if (prob(25))
						playsound(H.loc, 'sound/effects/bloody_stab.ogg', 100, 1)
						H.visible_message("<span style = \"color:red\"><b>[H]'s tail goes through [first]'s stomach and impales [m] too!</span></b>")
						m.TakeDamage("chest", rand(50,100), 0, 0, DAMAGE_STAB)

/datum/targetable/xenomorph/crush
	name = "Crush"
	desc = "Continuously leverage your weight against a carbon-based lifeform in order to crush them."
	cooldown = 50
	targeted = 0
	target_anything = 0
	restricted_area_check = 2

	cast(atom/target)
		if (..())
			return 1

		var/mob/living/carbon/human/H = holder.owner

		if (!istype(H))
			return

		if (!H.mutantrace)
			return

		if (!istype(H.mutantrace, /datum/mutantrace/xenomorph/praetorian))
			boutput(H, "Only Praetorians can use this ability. What the fuck are you doing here? Get out.")
			return

		if (H.mutantrace:plasma <= 200)
			boutput(H, "<span class='game xenobold'>You don't have enough plasma to use this ability.</span>")
			return

		H.mutantrace:plasma -= 200

		var/mob/living/l = H.find_xeno_target(2)

		var/was_dead = l.stat == 2

		var/l_loc = l.loc
		var/H_loc = H.loc

		if (l)
			if (l.lying)
				H.visible_message("<span style = \"color:red\"><b>[H] puts its massive claws on [l]'s chest, starting to crush them!</span></b>", "<span class='game xenobold'>You put your massive hands on [l]'s chest, starting to crush them!</span>")
				for (var/v = 1, v <= 10, v++)
					if (!l.lying)
						break

					if (H_loc != H.loc || l_loc != l.loc)
						break

					playsound(l.loc, 'sound/effects/gib.ogg', 100, 1)


					if (ishuman(l))
						var/mob/living/carbon/human/h = l
						h.emote("scream")

					l.TakeDamage("All", rand(20,30))

					if (prob(4 + was_dead ? 10 : 0))
						l.visible_message("<span style = \"color;red\"><font size = 3><b>[l] is crushed into gibs by [H]!</span></font></b>")
						l.gib()

					if (l)

						if (l.stat < 2 || was_dead)
							l.visible_message("<span style = \"color:red\"><b>[l] is crushed by [H]!</b></span>")
						else
							l.visible_message("<span style = \"color:red\"><b>[l] is crushed to death by [H]!</b></span>")

					else

						break

					sleep(rand(7,8))
			else
				boutput(H, "[l] must be lying for you to crush them.")

/datum/targetable/xenomorph/bioflashlight
	name = "Toggle Bioluminiscience"
	desc = "Emit a biolight that helps you locate hosts. Sentinels have very bright lights."
	icon_state = "genericlight"
	cooldown = 0
	targeted = 0
	target_anything = 0
	restricted_area_check = 2

	cast(atom/target)
		if (..())
			return 1

		var/mob/living/carbon/human/H = holder.owner

		if (!istype(H))
			return

		if (!isAlien(H))
			return

		H.mutantrace:xeno_light_on = !H.mutantrace:xeno_light_on
		H.update_alien_light()

		boutput(H, "<span class='game xeno'>You [H:mutantrace:xeno_light_on ? "toggle" : "detoggle"] your bioluminiscience.</span>")

/datum/targetable/xenomorph/kamikaze
	name = "Self-Explosion"
	icon_state = "explosion"
	desc = "Burst into a huge cloud of acid and take your enemies with you."
	cooldown = 25

	cast(atom/target)
		if (..())
			return 1

		var/mob/living/carbon/human/H = holder.owner

		if (!istype(H))
			return

		if (!istype(H.mutantrace, /datum/mutantrace/xenomorph/praetorian) && !istype(H.mutantrace, /datum/mutantrace/xenomorph/sentinel))
			boutput(H, "Only Praetorians can use this ability. What the fuck are you doing here? Get out.")
			return

		if (H.stunned >= 5)
			boutput(H, "You are too stunned to use this ability.")
			return

		switch (H.xblowingup)
			if (0)
				H.xblowingup = 1
				H.visible_message("<span style = \"color:red\"><b>[H]</b> starts to shake...</span>")
				boutput(H, "<span style = \"color:red\"><b>WARNING: You have used your self-destruction skill. If you wish to continue, use it again immediately after the delay.</span></b>")
				spawn (200)
					H.xblowingup = 0
				return
			if (1)
				H.xblowingup = 2//then continue on
				H.visible_message("<span style = \"color:red\"><b>[H]</b> starts to shake a lot!</span>")
				boutput(H, "<span style = \"color:red\"><b>WARNING: YOU WILL EXPLODE IF YOU USE THIS AGAIN!</span></b>")
				spawn (200)
					H.xblowingup = 0
				return
			if (2)
				H.xblowingup = 3//boom. no need to reset variable since their mob is gibbed

		var/datum/reagents/r = new/datum/reagents(500)
		r.add_reagent("s_m_acid", rand(300,400))

		if (isAlienSentinel(H))
			smoke_reaction(r, 7, H.loc, 0)
		else
			r.add_reagent("s_m_acid", 100)
			smoke_reaction(r, 10, H.loc, 0)

		spawn (4)//since the cloud takes time to set up
			H.visible_message("<span style = \"color:red\"><b>[H]</b> explodes in a cloud of deadly acid!</span>")
			playsound(H.loc, 'sound/effects/Explosion1.ogg', 100, 1)
			H.death()
			spawn (1)
				H.gib()

/datum/targetable/xenomorph/release_pheromones
	name = "Release Pheromones"
	desc = "Use pheromones to heal your fellow sisters or deal damage to hosts."
	icon_state = "acidgeneric"
	cooldown = 50
	targeted = 0
	target_anything = 0
	restricted_area_check = 2

	cast(atom/target)
		if (..())
			return 1

		var/mob/living/carbon/human/H = holder.owner

		if (!istype(H))
			return

		if (!isAlien(H))
			return

		if (!istype(H.mutantrace, /datum/mutantrace/xenomorph/drone) && !istype(H.mutantrace, /datum/mutantrace/xenomorph/praetorian))
			boutput(H, "You must be a praetorian or drone to use this ability, fuck off")
			return

		var/onoff = input("Turn your pheromones on or off?") in list ("On", "Off")

		if (onoff == "Off")
			H.mutantrace:pheromones = null
		else
			H.mutantrace:pheromones = input("Use what pheromone?") in list ("Infuriate Monkeys", "Heal Sisters", "Weaken Hosts", "Heal Hosts", "Expediate Hive Growth", "Reinforce Hive", "Cancel")
			if (H.mutantrace:pheromones == "Cancel")
				H.mutantrace:pheromones = null

			if (H.mutantrace:pheromones)
				H.mutantrace:init_pheromones()



/datum/targetable/xenomorph/secrete_acid_cloud
	name = "Secrete Acid Cloud"
	desc = "Create a deadly cloud of acid around you. Hosts will be forced to scatter, but it will also kill nested hosts."
	icon_state = "acidgeneric"
	cooldown = 5
	targeted = 0
	target_anything = 0
	restricted_area_check = 2

	cast(atom/target)
		if (..())
			return 1

		var/mob/living/C = holder.owner

		if (!C.loc || !istype(C.loc, /turf/simulated/floor))
			return 0

		if (!istype(C:mutantrace, /datum/mutantrace/xenomorph/sentinel) && !istype(C:mutantrace, /datum/mutantrace/xenomorph/praetorian))
			boutput(C, "NO GET OUT GET OUT GET OUT WARRIOR AND DRONE CASTES REEEEEEEEEEEEEEEEEEEEEEEEEEEEEE")
			return 0

		if (C:mutantrace:plasma < 150)
			boutput(C, "<span class='game xenobold'>You need at least 150 plasma to use this ability.</span>")
			return 0


		C:mutantrace:plasma-=150

		var/datum/reagents/r = new/datum/reagents()
		r.add_reagent("m_acid", rand(50,75))
		smoke_reaction(r, 5, C.loc, 0)

		C.visible_message("<font size = 3><span style = \"color:red\"><b>[C]</b> releases a cloud of deadly acid!</span></font>")

/datum/targetable/xenomorph/secrete_acid
	name = "Secrete Acid"
	desc = "Secrete acid into various objects, for fun effects. Mostly explosions. This will target the object in front of you."
	icon_state = "acidgeneric"
	cooldown = 5
	targeted = 0
	target_anything = 0
	restricted_area_check = 2

	cast(atom/target)
		if (..())
			return 1

		var/mob/living/C = holder.owner

		if (!C.loc || !istype(C.loc, /turf/simulated/floor))
			return 0
			/*

		if (!locate(/obj/reagent_dispensers) in get_step(C, C.dir) && !locate(/obj/burning_barrel) in get_step(C, C.dir) && !locate(/obj/machinery/light) in get_step(C, C.dir))
			return 0
			*/

		if (!istype(C:mutantrace, /datum/mutantrace/xenomorph/sentinel) && !istype(C:mutantrace, /datum/mutantrace/xenomorph/praetorian))
			boutput(C, "IM DONE WITH YOU GET OUT OF MY SWAMP")
			return 0

		if (C:mutantrace:plasma < 150)
			boutput(C, "<span class='game xenobold'>You need at least 150 plasma to use this ability.</span>")
			return 0


		C:mutantrace:plasma-=150



		var/C_loc = C.loc

		for (var/obj/reagent_dispensers/r in get_step(C, C.dir))
			C:visible_message("<span style = \"color:red\">[C] puts their tail inside [r], secreting acid into it.</span>")
			sleep(rand(3,6))
			if (C.loc != C_loc)
				return
			if (istype(r, /obj/reagent_dispensers/fueltank))//yeah, this means you'll die too
				r.visible_message("<span style = \"color:red\"><big>[r] explodes!</span></big>")
				explosion(null, r.loc, 3, 4, 5, 6)
				spawn (1)
					if (r)
						qdel(r)

				logTheThing("secreted acid into a fuel tank.", C, null)
				message_admins("[C]/[key_name(C)] secreted acid into a fuel tank.")
			return

		for (var/obj/burning_barrel/b in get_step(C, C.dir))
			C:visible_message("<span style = \"color:red\">[C] puts their tail inside [b], pumping acid into it.</span>")
			sleep(rand(3,6))
			if (C.loc != C_loc)
				return
			b.ex_act(1.0)
			spawn (rand(7,10))
				b.visible_message("<span style = \"color:red\">[b]'s flames start to flicker rapidly...</span>")
			spawn (rand(14,20))
				b.visible_message("<span stlye = \"color:red\">[b]'s flames start to glow very brightly...</span>")
			spawn (rand(21,30))
				b.visible_message("<span style = \"color:red\"><big>[b] explodes!</span></big>")
				explosion(null, b.loc, 2, 3, 4, 5)
				spawn (1)
					if (b)
						qdel(b)
				logTheThing("secreted acid into a burning barrel.", C, null)
				message_admins("[C]/[key_name(C)] secreted acid into a burning barrel.")
			return

		for (var/obj/machinery/light/l in get_step(C, C.dir))
			if (l.on)
				C:visible_message("<span style = \"color:red\">[C] puts their tail inside [l], pumping acid into it.</span>")
				sleep(rand(3,6))
				if (C.loc != C_loc)
					return
				spawn (rand(7,10))
					l.visible_message("<span style = \"color:red\">[l] starts to flicker rapidly...</span>")
				spawn (rand(14,20))
					l.visible_message("<span stlye = \"color:red\">[l] starts to glow very brightly...</span>")
				spawn (rand(21,30))
					l.visible_message("<span style = \"color:red\"><big>[l] explodes in a shower of sparks!</span></big>")
					explosion(null, l.loc, 1, 2, 3, 4)
					spawn (1)
						if (l)
							qdel(l)
					logTheThing("secreted acid into a light.", C, null)
					message_admins("[C]/[key_name(C)] secreted acid into a light.")
				return

		return 0
