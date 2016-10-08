/datum/ailment/disease/food_poisoning
	name = "Food Poisoning"
	max_stages = 3
	spread = "Non-Contagious"
	cure = "Sleep"
	associated_reagent = "salmonella"
	affected_species = list("Human")

	var/power = 1

	weak
		power = 1
		associated_reagent = "salmonella"
	med
		power = 2
		associated_reagent = "e.coli"
	strong
		power = 3
		associated_reagent = "peeium"
		cure = null
	verystrong
		power = 4
		associated_reagent = "rancidity"
		cure = null
//
/datum/ailment/disease/food_poisoning/stage_act(var/mob/living/affected_mob,var/datum/ailment_data/D)
	if (..())
		return
	switch(D.stage)
		if(1)
			if(prob(5 * power))
				boutput(affected_mob, "<span style=\"color:red\">Your stomach feels weird.</span>")
			if(prob(5 * power))
				boutput(affected_mob, "<span style=\"color:red\">You feel queasy.</span>")
		if(2)
			if(affected_mob.sleeping && prob(40/power) && power < 2)
				boutput(affected_mob, "<span style=\"color:blue\">You feel better.</span>")
				affected_mob.ailments -= src
				return
			if(prob(1) && prob(10))
				if (prob(100/power))
					boutput(affected_mob, "<span style=\"color:blue\">You feel better.</span>")
					affected_mob.ailments -= src
					return
			if(prob(10 * power))
				affected_mob.emote("groan")
			if(prob(5 * power))
				boutput(affected_mob, "<span style=\"color:red\">Your stomach aches.</span>")
			if(prob(5 * power))
				boutput(affected_mob, "<span style=\"color:red\">You feel nauseous.</span>")
		if(3)
			if(affected_mob.sleeping && prob(25) && power < 2)
				boutput(affected_mob, "<span style=\"color:blue\">You feel better.</span>")
				affected_mob.ailments -= src
				return
			if(prob(1) && prob(10))
				if (prob(100/power))
					boutput(affected_mob, "<span style=\"color:blue\">You feel better.</span>")
					affected_mob.ailments -= src
			if(prob(10 * power))
				affected_mob.emote("moan")
			if(prob(10 * power))
				affected_mob.emote("groan")
			if(prob(1 * power))
				boutput(affected_mob, "<span style=\"color:red\">Your stomach hurts.</span>")
			if(prob(1 * power))
				boutput(affected_mob, "<span style=\"color:red\">You feel sick.</span>")
			if(prob(5 * power))
				if (affected_mob.nutrition > 10)
					for(var/mob/O in viewers(affected_mob, null))
						O.show_message(text("<span style=\"color:red\">[] vomits on the floor profusely!</span>", affected_mob), 1)
					playsound(affected_mob.loc, "sound/effects/splat.ogg", 50, 1)
					new /obj/decal/cleanable/vomit(affected_mob.loc)
					affected_mob.nutrition -= rand(3,5)
				else
					boutput(affected_mob, "<span style=\"color:red\">Your stomach lurches painfully!</span>")
					for(var/mob/O in viewers(affected_mob, null))
						O.show_message(text("<span style=\"color:red\">[] gags and retches!</span>", affected_mob), 1)
					affected_mob.stunned += rand(2,4)
					affected_mob.weakened += rand(2,4)

					affected_mob.take_toxin_damage(power * 5)//raw meat is no longer a fucking joke