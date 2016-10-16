#define cycle_pause 5 //min 1
#define viewrange 7 //min 2




// Returns the surrounding cardinal turfs with open links
// Including through doors openable with the ID
// Includes spacetiles
/turf/proc/CardinalTurfsWithAccessSpace(var/obj/item/card/id/ID)
	var/L[] = new()
	for(var/d in cardinal)
		var/turf/simulated/T = get_step(src, d)
		if((istype(T) || istype(T,/turf/space))&& !T.density)
			if(!LinkBlockedWithAccess(src, T, ID))
				L.Add(T)
	return L
/obj/item/xeno
	ex_act(severity)
		switch(severity)
			if(1.0)
				qdel(src)
				return
			if(2.0)
				if (prob(90))
					qdel(src)
					return
			if(3.0)
				if (prob(80))
					qdel(src)
					return
			else
		return

/obj/item/xeno/resin
	name = "resin"
	icon = 'icons/tg-goon-xenos/xeno.dmi'
	icon_state = "chitin"

	var/stacked = 1

	density = 0.0

	examine()
		if (isAlien(usr))
			boutput(usr, "That's a chunk of resin.")
		else
			boutput(usr, "<span class = \"color:red\"><B>A strange resin object. You have a bad feeling about it...</B></span>")

/obj/item/xeno/facehugger
	name = "alien"
	desc = "An alien, looks pretty scary!"

	icon = 'icons/tg-goon-xenos/xeno.dmi'
	icon_state = "facehugger"

	layer = MOB_LAYER
	density = 0.0
	anchored = 0

	var/state = 0

	var/list/path = null

	var/frustration = 0
	var/mob/living/carbon/human/target
	var/list/path_target = null

	var/turf/trg_idle
	var/list/path_idle = null

	var/alive = 1 //1 alive, 0 dead
	var/maxhealth = 25

	flags = FPRINT | TABLEPASS

	New()
		..()
		health = maxhealth

	examine()
		set src in view()
		..()
		if(!alive)
			boutput(usr, text("<span style=\"color:red\"><B>This is a facehugger. It is not moving.</B></span>"))
		else if (src.health > 15)
			boutput(usr, text("<span style=\"color:red\"><B>This is a facehugger. It looks fresh and slimy, as though it just hatched.</B></span>"))
		else
			boutput(usr, text("<span style=\"color:red\"><B>This is a facehugger. It looks pretty beat up.</B></span>"))
		return

//	facehug(user as mob)
	//	if (isAlien(user))
	//		return 0



	attack_hand(user as mob)
		if (!isAlien(user))
			return 0
		else
			..()

	attackby(obj/item/W as obj, mob/user as mob)
		switch(W.damtype)
			if("fire")
				src.health -= W.force * 10
			if("brute")
				src.health -= W.force * 5
			else
		if (src.health <= 0)
			src.death()
		else if (W.force)
			if(ishuman(user) || ismonkey(user))
				src.target = user
				src.state = 1
		..()

	bullet_act(var/obj/projectile/P)
		var/damage = 0
		damage = round((P.power*P.proj_data.ks_ratio), 1.0)

		if((P.proj_data.damage_type == D_KINETIC)||(P.proj_data.damage_type == D_SLASHING))
			src.health -= (damage*2)
		else if(P.proj_data.damage_type == D_PIERCING)
			src.health -= damage
		else if(P.proj_data.damage_type == D_ENERGY)
			src.health -= damage
		else if(P.proj_data.damage_type == D_BURNING)
			src.health -= damage
		else if(P.proj_data.damage_type == D_RADIOACTIVE)
			src.health -= damage
		else if(P.proj_data.damage_type == D_TOXIC)
			src.health += damage
		healthcheck()

	ex_act(severity)
		switch(severity)
			if(1.0)
				src.death()
			if(2.0)
				src.health -= 15
				healthcheck()
		return

	meteorhit()
		src.death()
		return

	blob_act(var/power)
		if(prob(25))
			src.death()
		return
/*
	Bumped(AM as mob|obj)
		if(ismob(AM) && (ishuman(AM) || ismonkey(AM)) )
			src.target = AM
			set_attack()
		else if(ismob(AM))
			spawn(0)
				var/turf/T = get_turf(src)
				AM:set_loc(T)

	Bump(atom/A)
		if(ismob(A) && (ishuman(A) || ismonkey(A)))
			src.target = A
			set_attack()
		else if(ismob(A))
			src.set_loc(A:loc)

*/


/*
	verb/follow()
		set src in view()
		set name = "follow me"
		if(!alive) return
		if(!isAlien(usr))
			boutput(usr, text("<span style=\"color:red\"><B>The alien ignores you.</B></span>"))
			return
		if(state != 2 || health < maxhealth)
			boutput(usr, text("<span style=\"color:red\"><B>The alien is too busy to follow you.</B></span>"))
			return
		boutput(usr, text("<span style=\"color:green\"><B>The alien will now try to follow you.</B></span>"))
		trg_idle = usr
		path_idle = new/list()
		return

	verb/stop()
		set src in view()
		set name = "stop following"
		if(!alive) return
		if(!isAlien(usr))
			boutput(usr, text("<span style=\"color:red\"><B>The alien ignores you.</B></span>"))
			return
		if(state != 2)
			boutput(usr, text("<span style=\"color:red\"><B>The alien is too busy to follow you.</B></span>"))
			return
		boutput(usr, text("<span style=\"color:green\"><B>The alien stops following you.</B></span>"))
		set_null()
		return
*/


/*
	proc/call_to(var/mob/user)
		if(!alive || !isAlien(user) || state != 2) return
		trg_idle = user
		path_idle = null
		return

	proc/set_attack()
		state = 1
		path_idle = null
		trg_idle = null

	proc/set_idle()
		state = 2
		path_target = null
		target = null
		frustration = 0

	proc/set_null()
		state = 0
		path_target = null
		path_idle = null
		target = null
		trg_idle = null
		frustration = 0

	proc/onMobSee()
		var/quick_move = 0

		if (!alive)
			return

		if (!target)
			path_target = null

			var/last_health = INFINITY

			for (var/mob/living/carbon/human/C in range(viewrange-2,src.loc))
				if (isAlien(C) || C.alien_egg_flag || !can_see(src,C,viewrange))
					continue
				if(C:stunned || C:paralysis || C:weakened)
					target = C
					break
				if(C:health < last_health)
					last_health = C:health
					target = C

			if(target)
				set_attack()
			else if(state != 2)
				set_idle()
				idle()

		else if(target)
			var/turf/distance = get_dist(src, target)
			set_attack()

			if(can_see(src,target,viewrange))
				// This doesn't work, it only returns whenever a human is lying down on a tile
				// TO-DO think of a way to make it so they can't go through windows
				//var/turf/trg_turf = get_turf(target)
				if(distance <= 1) //&& trg_turf.Enter(src))
					for(var/mob/O in AIviewers(world.view,src))
						O.show_message("<span style=\"color:red\"><B>[src.target] has been leapt on by the alien!</B></span>", 1, "<span style=\"color:red\">You hear someone fall</span>", 2)
					random_brute_damage(target, 10)
					target:paralysis = max(target:paralysis, 10)
					src.set_loc(target.loc)

					if(!target.alien_egg_flag && ( ishuman(target) || ismonkey(target) ) )
						target.alien_egg_flag = 1
						var/mob/trg = target
						src.death(1)
						if (ishuman(trg))
							for (var/datum/ailment_data/data in trg.ailments)
								if (istype(data.master, /datum/ailment/parasite/alien_larva))
									return

							trg:contract_disease(/datum/ailment/parasite/alien_larva, null, null, 1)
						return
					else
						set_null()
						spawn(cycle_pause) src.onMobSee()
						return

				step_towards(src,get_step_towards2(src , target))
			else
				if(!path_target || !path_target.len )

					path_attack(target)
					if(!path_target)
						set_null()
						spawn(cycle_pause) src.onMobSee()
						return
				else
					var/turf/next = path_target[1]

					if(next in range(1,src))
						path_attack(target)

					if(!path_target || !path_target.len)
						src.frustration += 5
					else
						next = path_target[1]
						path_target -= next
						step_towards(src,next)
						quick_move = 1

			if (get_dist(src, src.target) >= distance) src.frustration++
			else src.frustration--
			if(frustration >= 35) set_null()

		if(quick_move)
			spawn(1)
				src.onMobSee()
		else
			spawn(cycle_pause)
				src.onMobSee()

	proc/idle()
		var/quick_move = 0

		if(state != 2 || !alive || target) return

		if(locate(/obj/xeno/hive/weeds) in src.loc && health < maxhealth)
			health++
			spawn(cycle_pause) idle()
			return

		if(!path_idle || !path_idle.len)
			//cast target idle into mob
			var/mob/trg_idle_mob

			if (ismob(trg_idle))
				trg_idle_mob = trg_idle
			//end casting
			if(isAlien(trg_idle_mob))
				if(can_see(src,trg_idle,viewrange))
					step_towards(src,get_step_towards2(src , trg_idle))
				else
					path_idle(trg_idle)
					if(!path_idle)
						trg_idle = null
						set_idle()
						spawn(cycle_pause) src.idle()
						return
			else
				var/obj/xeno/hive/weeds/W = null
				if(health < maxhealth)
					var/list/the_weeds = new/list()

					find_weeds:
						for(var/obj/xeno/hive/weeds/weed in range(viewrange,src.loc))
							if(!can_see(src,weed,viewrange)) continue
							for(var/atom/A in get_turf(weed))
								if(A.density) continue find_weeds
							the_weeds += weed
					W = pick(the_weeds)

				if(W)
					path_idle(W)
					if(!path_idle)
						trg_idle = null
						spawn(cycle_pause) src.idle()
						return
				else
					for(var/mob/living/carbon/human/H in range(1,src))
						if (H.mutantrace && istype(H.mutantrace, /datum/mutantrace/xenomorph))
							spawn(cycle_pause) src.idle()
							return
					step(src,pick(cardinal))

		else

			if(can_see(src,trg_idle,viewrange))
				switch(get_dist(src, trg_idle))
					if(1)
						if(istype(trg_idle,/obj/xeno/hive/weeds))
							step_towards(src,get_step_towards2(src , trg_idle))
					if(2 to INFINITY)
						step_towards(src,get_step_towards2(src , trg_idle))
						path_idle = null
					/*
					if(viewrange+1 to INFINITY)
						step_towards(src,get_step_towards2(src , trg_idle))
						if(path_idle.len) path_idle = new/list()
						quick_move = 1
					*/
			else
				var/turf/next = path_idle[1]
				if(!next in range(1,src))
					path_idle(trg_idle)

				if(!path_idle)
					spawn(cycle_pause) src.idle()
					return
				else
					next = path_idle[1]
					path_idle -= next
					step_towards(src,next)
					quick_move = 1

		if(quick_move)
			spawn(1)
				idle()
		else
			spawn(cycle_pause)
				idle()

	proc/path_idle(var/atom/trg)
		path_idle = AStar(src.loc, get_turf(trg), /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance)

	proc/path_attack(var/atom/trg)
		target = trg
		path_target = AStar(src.loc, target.loc, /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance)
*/

	proc/death(var/success = 0)
		if(!alive) return
		src.alive = 0
		density = 0
		if (success)
			icon_state = "facehugger_impregnated"
		else
			icon_state = "facehugger_dead"
	//	set_null()
		for(var/mob/O in hearers(src, null))
			O.show_message("<span style=\"color:red\"><B>[src] curls up into a ball!</B></span>", 1)

		playsound(loc, pick('sound/effects/alien/facehugger/death_0.ogg', 'sound/effects/alien/facehugger/death_1.ogg'), 100, 1)

//	proc/on_hug()
	//	playsound(loc, pick('sound/effects/alien/facehugger/attack_0.ogg', 'sound/effects/alien/facehugger/attack_1.ogg'), 100, 1)


	proc/healthcheck()
		if (src.health <= 0)
			src.death()

/proc/hugger_death_sound(var/atom/a)
//	if (isturf(a))
	//	playsound(a, pick('sound/effects/alien/facehugger/death_0.ogg', 'sound/effects/alien/facehugger/death_1.ogg'), 100, 1)
	//else
	playsound(a.loc, pick('sound/effects/alien/facehugger/death_0.ogg', 'sound/effects/alien/facehugger/death_1.ogg'), 100, 1)

/proc/hugger_hug_sound(var/atom/a)
//	if (isturf(a))
	playsound(a.loc, pick('sound/effects/alien/facehugger/attack_0.ogg', 'sound/effects/alien/facehugger/attack_1.ogg'), 100, 1)
//	else
//		playsound(a.loc, pick('sound/effects/alien/facehugger/attack_0.ogg', 'sound/effects/alien/facehugger/attack_1.ogg'), 100, 1)