/datum/ailment/parasite/spidereggs
	name = "Spider Eggs"
	max_stages = 5
	stage_prob = 8
	affected_species = list("Human", "Monkey")


/datum/ailment/parasite/alien_larva/surgery(var/mob/living/surgeon, var/mob/living/affected_mob, var/datum/ailment_data/D)
	if (D.disposed)
		return 0

	var/outcome = rand(90)
	if (surgeon.bioHolder.HasEffect("training_medical"))
		outcome += 10
	var/numb = affected_mob.reagents.has_reagent("morphine") || affected_mob.sleeping
	switch (outcome)
		if (0 to 5)
			// im doctor
			surgeon.visible_message("<span style=\"color:red\"><b>[surgeon] cuts open [affected_mob] in all the wrong places!</b></span>", "You dig around in [affected_mob]'s chest and accidentally snip something important looking!")
			affected_mob.show_message("<span style=\"color:red\"><b>You feel a [numb ? "numb" : "sharp"] stabbing pain in your chest!</b></span>")
			affected_mob.TakeDamage("chest", numb ? 37.5 : 75, 0, 0, DAMAGE_CUT)
			affected_mob.updatehealth()
			return 0
		if (6 to 15)
			surgeon.visible_message("<span style=\"color:red\"><b>[surgeon] clumsily cuts open [affected_mob]!</b></span>", "You dig around in [affected_mob]'s chest and accidentally snip something not so important looking!")
			affected_mob.show_message("<span style=\"color:red\"><b>You feel a [numb ? "mild " : " "]stabbing pain in your chest!</b></span>")
			affected_mob.TakeDamage("chest", numb ? 20 : 40, 0, 0, DAMAGE_CUT)
			affected_mob.updatehealth()
			return 0
		if (16 to 60)
			var/around_msg = ""
			var/self_msg = ""
			var/success = 0
			if (prob(50))
				around_msg = "<span style=\"color:blue\"><b>[surgeon] cuts open [affected_mob] and removes some [name].</b></span>"
				self_msg = "<span style=\"color:blue\">You remove some [name] from [affected_mob]. You can still see some of it in there, though.</span>"
			else
				around_msg = "<span style=\"color:blue\"><b>[surgeon] cuts open [affected_mob] and removes the remaining [name].</b></span>"
				self_msg = "<span style=\"color:blue\">You remove the remaining [name] from [affected_mob].</span>"
				success = 1
			surgeon.visible_message(around_msg, self_msg)
			if (!numb)
				affected_mob.show_message("<span style=\"color:red\"><b>You feel a mild stabbing pain in your chest!</b></span>")
				affected_mob.TakeDamage("chest", 10, 0, 0, DAMAGE_STAB)
				affected_mob.updatehealth()
			return success
		if (61 to INFINITY)
			surgeon.visible_message("<span style=\"color:blue\"><b>[surgeon] cuts open [affected_mob] and removes all traces of [name]</b></span>", "<span style=\"color:blue\">You masterfully remove the [name] from [affected_mob].</span>")
			if (!numb)
				affected_mob.show_message("<span style=\"color:red\"><b>You feel a mild stabbing pain in your chest!</b></span>")
				affected_mob.TakeDamage("chest", 10, 0, 0, DAMAGE_STAB)
				affected_mob.updatehealth()
			return 1

/datum/ailment/parasite/spidereggs/surgery(var/mob/living/surgeon, var/mob/living/affected_mob, var/datum/ailment_data/D)
	if (D.disposed)
		return 0
	if (affected_mob.reagents.has_reagent("spidereggs"))
		affected_mob.reagents.del_reagent("spidereggs")
	var/outcome = rand(90)
	if (surgeon.bioHolder.HasEffect("training_medical"))
		outcome += 10
	var/numb = affected_mob.reagents.has_reagent("morphine") || affected_mob.sleeping
	switch (outcome)
		if (0 to 5)
			// im doctor
			surgeon.visible_message("<span style=\"color:red\"><b>[surgeon] cuts open [affected_mob] in all the wrong places!</b></span>", "You dig around in [affected_mob]'s chest and accidentally snip something important looking!")
			affected_mob.show_message("<span style=\"color:red\"><b>You feel a [numb ? "numb" : "sharp"] stabbing pain in your chest!</b></span>")
			affected_mob.TakeDamage("chest", numb ? 37.5 : 75, 0, 0, DAMAGE_CUT)
			affected_mob.updatehealth()
			return 0
		if (6 to 15)
			surgeon.visible_message("<span style=\"color:red\"><b>[surgeon] clumsily cuts open [affected_mob]!</b></span>", "You dig around in [affected_mob]'s chest and accidentally snip something not so important looking!")
			affected_mob.show_message("<span style=\"color:red\"><b>You feel a [numb ? "mild " : " "]stabbing pain in your chest!</b></span>")
			affected_mob.TakeDamage("chest", numb ? 20 : 40, 0, 0, DAMAGE_CUT)
			affected_mob.updatehealth()
			return 0
		if (16 to 60)
			var/around_msg = ""
			var/self_msg = ""
			var/success = 0
			if (prob(50))
				around_msg = "<span style=\"color:blue\"><b>[surgeon] cuts open [affected_mob] and removes some [name].</b></span>"
				self_msg = "<span style=\"color:blue\">You remove some [name] from [affected_mob]. You can still see some of it in there, though.</span>"
			else
				around_msg = "<span style=\"color:blue\"><b>[surgeon] cuts open [affected_mob] and removes the remaining [name].</b></span>"
				self_msg = "<span style=\"color:blue\">You remove the remaining [name] from [affected_mob].</span>"
				success = 1
			surgeon.visible_message(around_msg, self_msg)
			if (!numb)
				affected_mob.show_message("<span style=\"color:red\"><b>You feel a mild stabbing pain in your chest!</b></span>")
				affected_mob.TakeDamage("chest", 10, 0, 0, DAMAGE_STAB)
				affected_mob.updatehealth()
			return success
		if (61 to INFINITY)
			surgeon.visible_message("<span style=\"color:blue\"><b>[surgeon] cuts open [affected_mob] and removes all traces of [name]</b></span>", "<span style=\"color:blue\">You masterfully remove the [name] from [affected_mob].</span>")
			if (!numb)
				affected_mob.show_message("<span style=\"color:red\"><b>You feel a mild stabbing pain in your chest!</b></span>")
				affected_mob.TakeDamage("chest", 10, 0, 0, DAMAGE_STAB)
				affected_mob.updatehealth()
			return 1


/datum/ailment/parasite/spidereggs/stage_act(var/mob/living/affected_mob,var/datum/ailment_data/D)
	if (..())
		return
	switch(D.stage)
		if(2)
			if(prob(3))
				affected_mob.reagents.add_reagent("histamine", 2)
		if(3)
			if(prob(5))
				affected_mob.reagents.add_reagent("histamine", 3)
		if(4)
			if(prob(12))
				affected_mob.reagents.add_reagent("histamine", 5)
		if(5)
			boutput(affected_mob, "<span style=\"color:red\">You feel like something is tearing its way out of your skin...</span>")
			affected_mob.reagents.add_reagent("histamine", 10)
			if(prob(30))
				affected_mob.emote("scream")
				var/babyspiders = null
				babyspiders = rand(3,5)
				if(prob(1))
					babyspiders = rand(6-12)
				while(babyspiders-- > 0)
					new/obj/critter/spider/ice/baby(affected_mob.loc)
				affected_mob.visible_message("<span style=\"color:red\"><b>[affected_mob] bursts open! Holy fuck!</b></span>")
				affected_mob:gib()
				return


//IBM note: haha this is the dumbest thing I have ever coded
/datum/ailment/parasite/bee_larva
	name = "Unidentified Foreign Body"
	max_stages = 5
	stage_prob = 8
	affected_species = list("Human", "Monkey")
	temperature_cure = INFINITY
//

/datum/ailment/parasite/bee_larva/stage_act(var/mob/living/affected_mob,var/datum/ailment_data/D)
	if (..())
		return
	switch(D.stage)
		if (2, 3)
			if(prob(1))
				affected_mob.emote("sneeze")
			if(prob(1))
				affected_mob.emote("cough")
			if(prob(1))
				boutput(affected_mob, "<span style=\"color:red\">Your throat feels sore.</span>")
			if(prob(1))
				boutput(affected_mob, "<span style=\"color:red\">Mucous runs down the back of your throat.</span>")
		if(4)
			if(prob(1))
				affected_mob.emote("sneeze")
			if(prob(1))
				affected_mob.emote("cough")
			if(prob(2))
				boutput(affected_mob, "<span style=\"color:red\">Your stomach hurts.</span>")
				if(prob(20))
					affected_mob.take_toxin_damage(1)
					affected_mob.updatehealth()
		if(5)
			boutput(affected_mob, "<span style=\"color:red\">You feel something tearing its way out of your stomach...</span>")
			if (affected_mob.get_toxin_damage() < 30)
				affected_mob.take_toxin_damage(10)
			affected_mob.updatehealth()

			if(prob(40))
				var/obj/critter/domestic_bee_larva/larva = new /obj/critter/domestic_bee_larva (get_turf(affected_mob))
				larva.name = "li'l [affected_mob:real_name]"
				if (affected_mob.bioHolder && affected_mob.bioHolder.mobAppearance)
					larva.color = "[affected_mob.bioHolder.mobAppearance.customization_first_color]"
					if (!affected_mob.bioHolder.mobAppearance.customization_first_color)
						larva.color = "#FFFFFF"

				larva.beeMom = affected_mob
				larva.beeMomCkey = affected_mob.ckey
				playsound(affected_mob.loc, "sound/effects/splat.ogg", 50, 1)
				affected_mob.visible_message("<span style=\"color:red\"><b>[affected_mob] horks up a bee larva!  Grody!</b></span>", "<span style=\"color:red\"><b>You cough up...a bee larva. Uhhhhh</b></span>")

				affected_mob.cure_disease(D)
				return
//alien larva, copypasta from bee larva
/datum/ailment/parasite/alien_larva
	name = "Unidentified Foreign Body"
	max_stages = 5
	stage_prob = 15
	affected_species = list("Human", "Monkey")
	temperature_cure = INFINITY
//

/*
	var/available[0]

	for (var/mob/living/carbon/human/larva in world)
		if (istype(larva.mutantrace, /datum/mutantrace/xenomorph/larva))
			if (!larva.client)
				available += larva
	join_as_alien(pick(available))


/mob/dead/observer/proc/join_as_alien(var/mob/living/carbon/human/larva)

	if (src.mind.transfer_to(larva))
		boutput(src, "<span style=\"color:red\"><b>You have been born.</span></b>")
		playsound(larva, larva.mutantrace:sound_alienroar, 100, 1)
*/

/datum/ailment/parasite/alien_larva/stage_act(var/mob/living/affected_mob,var/datum/ailment_data/D)
	if (..())
		return
	switch(D.stage)
		if (2, 3)
			if(prob(1))
				affected_mob.emote("sneeze")
			if(prob(1))
				affected_mob.emote("cough")
			if(prob(1))
				boutput(affected_mob, "<span style=\"color:red\">Your throat feels sore.</span>")
			if(prob(1))
				boutput(affected_mob, "<span style=\"color:red\">Mucous runs down the back of your throat.</span>")
		if(4)
			if(prob(1))
				affected_mob.emote("sneeze")
			if(prob(1))
				affected_mob.emote("cough")
			if(prob(2))
				boutput(affected_mob, "<span style=\"color:red\">Your stomach hurts.</span>")
				if(prob(20))
					affected_mob.take_toxin_damage(1)
					affected_mob.updatehealth()
		if(5)
			var/datum/mind/availableminds[0]
			for (var/mob/dead/observer/O in world)
				if (O.client && O.key && O.client.preferences.be_xenomorph)
					if (O.mind)
						availableminds+=O.mind

			if (affected_mob.client && affected_mob.client.preferences.be_xenomorph && affected_mob.key)
				if (affected_mob.mind)
					availableminds+=affected_mob.mind

			if (!availableminds.len)//nobody wants to be an alien? Fuck you, now you're all candidates!
				for (var/mob/dead/observer/O in world)
					if (O.client && O.key)
						if (O.mind)
							availableminds += O.mind

				if (affected_mob.client && affected_mob.key)
					availableminds += affected_mob.mind

			if (availableminds.len)
				boutput(affected_mob, "<span style=\"color:red\">You feel like something is tearing its way out of your skin...</span>")
				affected_mob.reagents.add_reagent("histamine", 10)

			if(prob(10))//was prob(30)
				if (affected_mob.stat != 2)
					affected_mob.emote("scream")

				var/new_loc = affected_mob.loc

				if (availableminds.len)
				//	var/mob/new_player/larva = new/mob/new_player(affected_mob.loc)
				//	larva.on_login(1)
					affected_mob.visible_message("<span style=\"color:red\"><b>[affected_mob] bursts open in a shower of gibs!</b></span>")
					affected_mob:gib()

					spawn (1)//allows the burster to be their larva

						var/datum/mind/mind = pick(availableminds)
						var/mob/dead/observer = mind.current//we add affected_mob's
						//mind, but they should already be gibbed now

						var/mob/dead/observer/main_candidate = affected_mob:parasitoid_priority
						if (main_candidate && istype(main_candidate, /mob/dead/observer) && main_candidate.mind)
							mind = main_candidate.mind
							observer = main_candidate.mind.current

						var/iteration = 1

						while (!observer || !istype(observer))
							if (iteration > 10)
								break
							mind = pick(availableminds)
							observer = mind.current
							iteration++

						if (observer)
							boutput(observer, "<span style=\"color:red\"><b>You have been born.</span></b>")


							//O.mind.transfer_to(larva)
							if (new_loc)
								observer.loc = new_loc

							var/o_loc = observer.loc

							observer.make_true_xenomorph(0, 1)

							var/newalien

							for (var/mob/living/carbon/human/H in o_loc)
								if (isAlien(H))
									newalien = H

							if (newalien)
								var/newalien_area

								if (istype(newalien:loc, /atom/movable))
									newalien_area = newalien:loc:loc:loc
								else
									newalien_area = newalien:loc:loc

								for (var/mob/living/carbon/human/H in mobs)
									if (isAlien(H))
										boutput(H, "<span style=\"color:red\"><b>Hivemind: [newalien] has been born at [newalien_area], killing a host.</span></b>")
					//larva.make_true_xenomorph(0, 1)
				else
				//	if (prob(25))//apparently it's difficult to make xenomorphs w/o
						//clients using the current system so I'm just going to make
						//the hosts explode if nobody is available
					affected_mob.visible_message("<span style=\"color:red\"><b>[affected_mob] bursts open in a shower of gibs!</b></span>")
					affected_mob:gib()