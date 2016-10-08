/datum/targetable/xenomorph/rend
	name = "Rend"
	desc = "Severely wound a host by rending them with your teeth. They will most likely bleed to death."
	icon_state = "resinp"
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

		if (H.mutantrace:plasma < 200)
			boutput(H, "You require at least 200 plasma to use this ability.")
			return
		else
			H.mutantrace:plasma -= 200


		var/obj/item/grab/G = src.grab_check(null, 1, 1)

		for (var/mob/living/l in get_step(H, H.dir))
			if (H.pulling == l || G.affecting && G.affecting == l)
				l.visible_message("<span style = \"color:red\"><b>[H] brutally rends [l] with their sharp teeth!</span></b>")
				l.TakeDamage("chest", 50, 0, 0, DAMAGE_CUT)

				break

/datum/targetable/xenomorph/penetrate
	name = "Skull Penetration"
	desc = "Use your inner mouth to penetrate the skull and instantly kill any living being. They must be incapacitated."
	icon_state = "resinp"
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

		if (!H.mutantrace)
			return

		if (!istype(H.mutantrace, /datum/mutantrace/xenomorph/warrior))
			boutput(H, "Only Warriors can use this ability. What the fuck are you doing here? Get out.")
			return

		if (H.mutantrace:plasma < 200)
			boutput(H, "You require at least 200 plasma to use this ability.")
			return
		else
			H.mutantrace:plasma -= 200


		var/obj/item/grab/G = src.grab_check(null, 1, 1)

		for (var/mob/living/l in get_step(H, H.dir))
			if (H.pulling == l || G.affecting && G.affecting == l)
				H.visible_message("<span style = \"color:red\">[H] grabs [l], bringing their head up to its mouth...</span>", "<span style = \"color:red\">You grab [l], bringing its head up to your mouth...</span>")
				var/l_loc = l.loc
				var/H_loc = H.loc
				spawn (rand(10,15))
					if (H.loc == H_loc && l.loc == l_loc)
						l.visible_message("<span style = \"color:red\"><big>[H] sends its inner mouth directly through [l]'s head!</span></b>")
						l.TakeDamageAccountArmor("head", 10000)//rip

				break

/datum/targetable/xenomorph/rip_apart
	name = "Rip Apart"
	desc = "Rip apart a host, almost instantly gibbing them."
	icon_state = "resinp"
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

		if (!H.mutantrace)
			return

		if (!istype(H.mutantrace, /datum/mutantrace/xenomorph/praetorian))
			boutput(H, "Only Praetorians can use this ability. What the fuck are you doing here? Get out.")

		if (H.mutantrace:plasma < 200)
			boutput(H, "You require at least 200 plasma to use this ability.")
			return
		else
			H.mutantrace:plasma -= 200

		var/obj/item/grab/G = src.grab_check(null, 1, 1)

		for (var/mob/living/l in get_step(H, H.dir))
			if (H.pulling == l || G.affecting && G.affecting == l)
				H.visible_message("<span style = \"color:red\">[H] grabs [l], lifting them into the air..</span>", "<span style = \"color:red\">You grab [l], lifting them into the air..</span>")
				var/l_loc = l.loc
				var/H_loc = H.loc
				spawn (rand(15,20))
					if (H.loc == H_loc && l.loc == l_loc)
						l.visible_message("<span style = \"color:red\"><big>[H] rips [l] apart!</span></big>")
						l.gib()
				break


/datum/targetable/xenomorph/spit
	name = "Spit"
	desc = "Spit neurotoxin at a host to weaken, but not harm them."
	icon_state = "resinp"
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

		if (!H.mutantrace)
			return

		if (!istype(H.mutantrace, /datum/mutantrace/xenomorph/praetorian) && !istype(H.mutantrace, /datum/mutantrace/xenomorph/sentinel))
			boutput(H, "Only Praetorians/Sentinels can use this ability. What the fuck are you doing here? Get out.")

		if (H.mutantrace:plasma < 75)
			boutput(H, "You require at least 75 plasma to use this ability.")
			return
		else
			H.mutantrace:plasma -= 75

		var/mob/living/targ = null

		for (var/mob/living/m in range(10, H))

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

		var/datum/projectile/energy_bolt/neurotoxin/n = new/datum/projectile/energy_bolt/neurotoxin()

		/*var/obj/projectile/P = */
		shoot_projectile_ST_pixel_spread(H, n, targ, 0, 0, 0)
		//if (P)
		//	alter_projectile(P)
		//	P.forensic_ID = src.forensic_ID

/datum/targetable/xenomorph/slam
	name = "Slam"
	desc = "Leverage your body weight against a host or object to send it flying. This will destroy almost all immobile objects."
	icon_state = "resinp"
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

		if (!H.mutantrace)
			return

		if (!istype(H.mutantrace, /datum/mutantrace/xenomorph/praetorian))
			boutput(H, "Only Praetorians can use this ability. What the fuck are you doing here? Get out.")

		if (H.mutantrace:plasma < 300)
			boutput(H, "You don't have enough plasma to use this ability.")
			return

		for (var/mob/living/l in get_step(H, H.dir))
			H.visible_message("<span style = \"color:red\"><big>[H] slams its massive body into [l]!</span></big>", "<span style = \"color:red\"><big>You slam your massive body into [l]!</span></big>")
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
				H.visible_message("<span style = \"color:red\">[H] slams its massive body into [a], crushing it into pieces!</span>")
				a.ex_act(1.0)
				spawn (1)
					if (a)
						qdel(a)
			else
				if (!ismob(a))
					step_away(a, H)
					if (prob(80))
						step_away(a, H)
					if (prob(70))
						step_away(a, H)

					a.ex_act(3.0)


/datum/targetable/xenomorph/tailwhip
	icon_state = "resinp"
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

		if (!H.mutantrace)
			return

		if (!istype(H.mutantrace, /datum/mutantrace/xenomorph/praetorian))
			boutput(H, "Only Praetorians can use this ability. What the fuck are you doing here? Get out.")

		if (H.mutantrace:plasma < 100)
			boutput(H, "You don't have enough plasma to use this ability.")
			return

		H.mutantrace:plasma -= 100

		H.visible_message("<span style = \"color:red\">[H] sweeps its long tail across the floor!</span>")

		for (var/mob/living/l in range(2, H))
			if (isAlien(l))
				continue
			if (l.lying)
				continue

			l.visible_message("<span style = \"color:red\">[l] is hit by [H]'s tail!</span>")
			l.remove_stamina(5)
			l.weakened += 3
			l.TakeDamage("All", rand(10,20), 0, 0, DAMAGE_BLUNT)

			break

/datum/targetable/xenomorph/crush
	name = "Crush"
	desc = "Leverage your weight against a carbon-based lifeform in order to crush them."
	icon_state = "resinp"
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

		if (!H.mutantrace)
			return

		if (!istype(H.mutantrace, /datum/mutantrace/xenomorph/praetorian))
			boutput(H, "Only Praetorians can use this ability. What the fuck are you doing here? Get out.")

		if (H.mutantrace:plasma <= 300)
			boutput(H, "You don't have enough plasma to use this ability.")
			return

		H.mutantrace:plasma -= 300

		for (var/mob/living/l in get_step(H, H.dir))
			if (isAlien(l))
				continue
			if (l.stat == 2)
				continue

			if (l.lying)
				H.visible_message("<span style = \"color:red\">[H] puts its massive hands on [l]'s chest, starting to crush them!</span>", "<span style = \"color:red\">You put your massive hands on [l]'s chest, starting to crush them!</span>")
				for (var/v = 1, v <= 10, v++)
					if (!l.lying)
						break

					if (ishuman(l))
						var/mob/living/carbon/human/h = l
						h.emote("scream")

					l.TakeDamage("All", rand(20,30))

					if (prob(4))
						l.gib()

					if (l)

						if (l.stat < 2)
							l.visible_message("<span style = \"color:red\"><b>[l] is crushed by [H]!</b></span>")
						else
							l.visible_message("<span style = \"color:red\"><b>[l] is crushed to death by [H]!</b></span>")

					else

						break

					sleep(rand(4,5))
			else
				boutput(H, "[l] must be lying for you to crush them.")

			break

/datum/targetable/xenomorph/bioflashlight
	name = "Toggle Bioluminiscience"
	desc = "Emit a biolight that helps you locate hosts. Sentinels have very bright lights."
	icon_state = "resinp"
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

		boutput(H, "<span style = \"color:blue\">You [H:mutantrace:xeno_light_on ? "toggle" : "detoggle"] your bioluminiscience.</span>")

/datum/targetable/xenomorph/kamikaze
	name = "Self-Explosion"
	desc = "Burst into a huge cloud of acid and take your enemies with you."

	cast(atom/target)
		if (..())
			return 1

		var/mob/living/carbon/human/H = holder.owner

		if (!istype(H))
			return

		if (!istype(H.mutantrace, /datum/mutantrace/xenomorph/praetorian) && !istype(H.mutantrace, /datum/mutantrace/xenomorph/sentinel))
			boutput(H, "Only Praetorians can use this ability. What the fuck are you doing here? Get out.")
			return


		var/datum/reagents/r = new/datum/reagents(500)
		r.add_reagent("m_acid", 500)
		smoke_reaction(r, 7, H.loc, 0)

		spawn (4)//since the cloud takes tiem to set up
			H.visible_message("<span style = \"color:red\"><b>[H]</b> explodes in a cloud of deadly acid!</span>")

			H.death()
			spawn (1)
				H.gib()

/datum/targetable/xenomorph/release_pheromones
	name = "Release Pheromones"
	desc = "Use pheromones to heal your fellow sisters or deal damage to hosts."
	icon_state = "resinp"
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
	icon_state = "resinp"
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

		if (!istype(C:mutantrace, /datum/mutantrace/xenomorph/sentinel) && !istype(C:mutantrace, /datum/mutantrace/xenomorph/praetorian))
			boutput(C, "<span style = \"color:red\"><B>Your caste cannot secrete acid.</span></B>")
			return 0

		if (C:mutantrace:plasma < 200)
			boutput(C, "<span style = \"color:red\"><B>You need at least 200 plasma to use this ability.</span></B>")
			return 0


		C:mutantrace:plasma-=200

		var/datum/reagents/r = new/datum/reagents()
		r.add_reagent("m_acid", 50)
		smoke_reaction(r, 5, C.loc, 0)

		C.visible_message("<span style = \"color:red\"><b>[C]</b> releases a cloud of deadly acid!</span>")

/datum/targetable/xenomorph/secrete_acid
	name = "Secrete Acid"
	desc = "Secrete acid into various objects, for fun effects. Mostly explosions. This target the object in front of you."
	icon_state = "resinp"
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

		if (!locate(/obj/reagent_dispensers) in get_step(C, C.dir) && !locate(/obj/burning_barrel) in get_step(C, C.dir) && !locate(/obj/machinery/light) in get_step(C, C.dir))
			return 0

		if (!istype(C:mutantrace, /datum/mutantrace/xenomorph/sentinel) && !istype(C:mutantrace, /datum/mutantrace/xenomorph/praetorian))
			boutput(C, "<span style = \"color:red\"><B>Your caste cannot secrete acid.</span></B>")
			return 0

		if (C:mutantrace:plasma < 100)
			boutput(C, "<span style = \"color:red\"><B>You need at least 100 plasma to use this ability.</span></B>")
			return 0


		C:mutantrace:plasma-=100



		for (var/obj/reagent_dispensers/r in get_step(C, C.dir))
			if (istype(r, /obj/reagent_dispensers/fueltank))
				r.visible_message("<span style = \"color:red\"><big>[r] explodes!</span></big>")
				explosion(null, r.loc, rand(2,3), rand(3,4), rand(4,5), rand(6,7))
				spawn (1)
					if (r)
						qdel(r)

				logTheThing("secreted acid into a fuel tank.", C, null)
				message_admins("[C] secreted acid into a fuel tank.")

		for (var/obj/burning_barrel/b in get_step(C, C.dir))
			b.ex_act(1.0)
			spawn (rand(7,10))
				b.visible_message("<span style = \"color:red\">[b]'s flames start to flicker rapidly...</span>")
			spawn (rand(7,10))
				b.visible_message("<span stlye = \"color:red\">[b]'s flames start to glow very brightly...</span>")
			spawn (rand(7,10))
				b.visible_message("<span style = \"color:red\"><big>[b] explodes!</span></big>")
				explosion(null, b.loc, rand(2,3), rand(3,4), rand(4,5), rand(6,7))
				spawn (1)
					if (b)
						qdel(b)
				logTheThing("secreted acid into a burning barrel.", C, null)
				message_admins("[C] secreted acid into a burning barrel.")

		for (var/obj/machinery/light/l in get_step(C, C.dir))
			spawn (rand(7,10))
				l.visible_message("<span style = \"color:red\">[l] starts to flicker rapidly...</span>")
			spawn (rand(7,10))
				l.visible_message("<span stlye = \"color:red\">[l] starts to glow very brightly...</span>")
			spawn (rand(7,10))
				l.visible_message("<span style = \"color:red\"><big>[l] explodes in a shower of sparks!</span></big>")
				explosion(null, l.loc, rand(1,2), rand(2,3), rand(3,4), rand(5,6))
				spawn (1)
					if (l)
						qdel(l)
				logTheThing("secreted acid into a light.", C, null)
				message_admins("[C] secreted acid into a light.")

		return 0
