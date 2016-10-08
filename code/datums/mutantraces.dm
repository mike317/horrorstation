// mutant races: cheap way to add new "types" of mobs
// without copy/pasting the human code a million times.
// Now a robust object-oriented version!!!!

/datum/mutantrace
	var/stamina_divider = 1

	var/name = null				// used for identification in diseases, clothing, etc
	var/override_human_stuff = 0
	var/override_damage_detail = 0
	var/override_blood = 0
	var/override_fireover = 0

	var/override_eyes = 1
	var/override_hair = 1
	var/override_beard = 1
	var/override_detail = 1
	var/override_skintone = 1
	var/override_attack = 1     // set to 1 to override the limb attack actions. Mutantraces may use the limb action within custom_attack(),
								// but they must explicitly specify if they're overriding via this var
	var/override_language = null // set to a language ID to replace the language of the human
	var/understood_languages = list() // additional understood languages (in addition to override_language if set, or english if not)
	var/allow_fat = 0			// whether fat icons/disabilities are used
	var/uses_special_head = 0	// unused
	var/human_compatible = 1	// if 1, allows human diseases and dna injectors to affect this mutantrace
	var/uses_human_clothes = 1	// if 0, can only wear clothes listed in an item's compatible_species var
	var/exclusive_language = 0	// if 1, only understood by others of this mutantrace
	var/voice_message = null	// overrides normal voice message if defined (and others don't understand us, ofc)
	var/voice_name = "human"
	var/jerk = 0				// Should robots arrest these by default?

	var/list/emotes_allowed

	var/icon = 'icons/effects/genetics.dmi'
	var/icon_state = "epileptic"
	var/icon_head = null
	var/icon_beard = null

	var/head_offset = 0 // affects pixel_y of clothes
	var/hand_offset = 0
	var/body_offset = 0

	var/pixelXoffset = 0

	var/r_limb_type_mutantrace = null // Should we get custom arms? Dispose() replaces them with normal human arms.
	var/l_limb_type_mutantrace = null
	var/ignore_missing_limbs = 0 // Replace both arms regardless of mob status (new and dispose).

	var/firevuln = 1 //Scales damage, just like critters.
	var/brutevuln = 1

	var/bonus_damage_first = 0
	var/bonus_damage_second = 0

	var/mob/living/carbon/human/mob = null

	proc/say_filter(var/message)
		return message

	proc/say_verb()
		return "says"

	proc/emote(var/act)
		return null

	// custom attacks, should return attack_hand by default or bad things will happen!!
	// ^--- Outdated, please use limb datums instead if possible.
	proc/custom_attack(atom/target)
		return target.attack_hand(mob)

	// movement delay modifier
	proc/movement_delay()
		return 0

	proc/onMove()
		return null

	// vision modifier (see_mobs, etc i guess)
	proc/sight_modifier()
		return

	proc/onLife()	//Called every Life cycle of our mob
		return

	proc/get_bonus_damage()
		return rand(bonus_damage_first, bonus_damage_second)

	proc/onDeath() //Called when our mob dies.  Returning a true value will short circuit the normal death proc right before deathgasp/headspider/etc
		return

	proc/onRevive()
		return

	New(var/mob/living/carbon/human/M)
		..()

		if(ishuman(M))
			src.mob = M
			var/list/obj/item/clothing/restricted = list(mob.w_uniform, mob.shoes, mob.wear_suit)
			for(var/obj/item/clothing/W in restricted)
				if (istype(W,/obj/item/clothing))
					if(W.compatible_species.Find(src.name) || (src.human_compatible && W.compatible_species.Find("human")))
						continue
					mob.u_equip(W)
					boutput(mob, "<span style=\"color:red\"><B>You can no longer wear the [W.name] in your current state!</B></span>")
					if (W)
						W.set_loc(mob.loc)
						W.dropped(mob)
						W.layer = initial(W.layer)
			M.image_eyes.pixel_y = src.head_offset
			M.image_cust_one.pixel_y = src.head_offset
			M.image_cust_two.pixel_y = src.head_offset
			M.image_cust_three.pixel_y = src.head_offset

			// Replacement for custom_attack() of several mutantraces, which used an entire copy of
			// pre-stamina melee code. They do the same stuff with more flexible limb datums (Convair880).
			if (!isnull(src.r_limb_type_mutantrace))
				if (M.limbs.r_arm || src.ignore_missing_limbs == 1)
					var/obj/item/parts/human_parts/arm/limb = new src.r_limb_type_mutantrace(M)
					if (limb && istype(limb))
						qdel(M.limbs.r_arm)
						limb.quality = 0.5
						M.limbs.r_arm = limb
						limb.holder = M
						limb.remove_stage = 0

			if (!isnull(src.l_limb_type_mutantrace))
				if (M.limbs.l_arm || src.ignore_missing_limbs == 1)
					var/obj/item/parts/human_parts/arm/limb2 = new src.l_limb_type_mutantrace(M)
					if (limb2 && istype(limb2))
						qdel(M.limbs.l_arm)
						limb2.quality = 0.5
						M.limbs.l_arm = limb2
						limb2.holder = M
						limb2.remove_stage = 0

			M.update_face()
			M.update_body()

			spawn (25) // Don't remove.
				if (M && M.organHolder && M.organHolder.skull)
					M.assign_gimmick_skull() // For predators (Convair880).

			if (istype(src, /datum/mutantrace/xenomorph))
				src.mob.full_heal()
				src.mob.updatehealth()

		else
			src.dispose()
		return

	disposing()
		if(mob)
			mob.mutantrace = null
			mob.set_face_icon_dirty()
			mob.set_body_icon_dirty()

			var/list/obj/item/clothing/restricted = list(mob.w_uniform, mob.shoes, mob.wear_suit)
			for (var/obj/item/clothing/W in restricted)
				if (istype(W,/obj/item/clothing))
					if (W.compatible_species.Find("human"))
						continue
					mob.u_equip(W)
					boutput(mob, "<span style=\"color:red\"><B>You can no longer wear the [W.name] in your current state!</B></span>")
					if (W)
						W.set_loc(mob.loc)
						W.dropped(mob)
						W.layer = initial(W.layer)

			if (istype(mob,/mob/living/carbon/human/))
				var/mob/living/carbon/human/H = mob
				H.image_eyes.pixel_y = initial(H.image_eyes.pixel_y)
				H.image_cust_one.pixel_y = initial(H.image_cust_one.pixel_y)
				H.image_cust_two.pixel_y = initial(H.image_cust_two.pixel_y)
				H.image_cust_three.pixel_y = initial(H.image_cust_three.pixel_y)

				// And the other way around (Convair880).
				if (!isnull(src.r_limb_type_mutantrace))
					if (H.limbs.r_arm || src.ignore_missing_limbs == 1)
						var/obj/item/parts/human_parts/arm/limb = new /obj/item/parts/human_parts/arm/right(H)
						if (limb && istype(limb))
							qdel(H.limbs.r_arm)
							limb.quality = 0.5
							H.limbs.r_arm = limb
							limb.holder = H
							limb.remove_stage = 0

				if (!isnull(src.l_limb_type_mutantrace))
					if (H.limbs.l_arm || src.ignore_missing_limbs == 1)
						var/obj/item/parts/human_parts/arm/limb2 = new /obj/item/parts/human_parts/arm/left(H)
						if (limb2 && istype(limb2))
							qdel(H.limbs.l_arm)
							limb2.quality = 0.5
							H.limbs.l_arm = limb2
							limb2.holder = H
							limb2.remove_stage = 0

				H.set_face_icon_dirty()
				H.set_body_icon_dirty()

				spawn (25) // Don't remove.
					if (H && H.organHolder && H.organHolder.skull) // check for H.organHolder as well so we don't get null.skull runtimes
						H.assign_gimmick_skull() // We might have to update the skull (Convair880).

			mob.set_clothing_icon_dirty()
			src.mob = null

		..()
		return

/datum/mutantrace/flashy
	name = "flashy"
	override_eyes = 0
	override_hair = 0
	override_beard = 0
	override_detail = 0
	override_attack = 0

/datum/mutantrace/virtual
	name = "virtual"
	icon_state = "virtual"
	override_attack = 0

/datum/mutantrace/blank
	name = "blank"
	icon_state = "blank"
	override_eyes = 0
	override_hair = 0
	override_beard = 0
	override_detail = 0
	override_attack = 0

/datum/mutantrace/lizard
	name = "lizard"
	icon_state = "lizard"
	allow_fat = 1
	override_attack = 0

	sight_modifier()
		mob.see_in_dark = SEE_DARK_HUMAN + 1
		mob.see_invisible = 1

	say_filter(var/message)
		return replacetext(message, "s", stutter("ss"))

/datum/mutantrace/zombie
	name = "zombie"
	icon_state = "zombie"
	override_hair = 0
	override_beard = 0
	override_detail = 0
	jerk = 1

	sight_modifier()
		mob.sight |= SEE_MOBS
		mob.see_in_dark = SEE_DARK_FULL
		mob.see_invisible = 0

	movement_delay()
		return 3

	say_filter(var/message)
		return pick("Urgh...", "Brains...", "Hungry...")

	onDeath()
		mob.show_message("<span style=\"color:blue\">You can feel your flesh re-assembling. You will rise once more.</span>")
		spawn(200)
			if (mob)
				mob.HealDamage("All", 1000, 1000)
				mob.take_toxin_damage(-INFINITY)
				mob.take_oxygen_deprivation(-INFINITY)
				mob.take_eye_damage(-INFINITY)
				mob.paralysis = 0
				mob.stunned = 0
				mob.weakened = 0
				mob.radiation = 0
				mob.take_brain_damage(-120)
				mob.health = mob.max_health
				mob.updatehealth()
				if (mob.stat > 1)
					mob.stat=0
				//..()
				mob.emote("scream")
				mob.visible_message("<span style=\"color:red\"><B>[mob]</B> rises from the dead!</span>")

		return 1

/datum/mutantrace/skeleton
	name = "skeleton"
	icon = 'icons/mob/human.dmi'
	icon_state = "skeleton"

/*
/datum/mutantrace/ape
	name = "ape"
	icon_state = "ape"
*/

/datum/mutantrace/nostalgic
	name = "Homo nostalgius"
	icon_state = "oldhuman"
	override_skintone = 0
	override_attack = 0

/datum/mutantrace/abomination
	name = "abomination"
	icon_state = "abomination"
	human_compatible = 0
	uses_human_clothes = 0
	jerk = 1
	brutevuln = 0.2
	override_attack = 0
	r_limb_type_mutantrace = /obj/item/parts/human_parts/arm/right/abomination
	l_limb_type_mutantrace = /obj/item/parts/human_parts/arm/left/abomination
	ignore_missing_limbs = 1

	var/last_drain = 0
	var/drains_dna_on_life = 1
	var/ruff_tuff_and_ultrabuff = 1

	New(var/mob/living/carbon/human/M)
		if(ruff_tuff_and_ultrabuff && M)
			M.add_stam_mod_max("abomination", 1000)
			M.add_stam_mod_regen("abomination", 1000)

		last_drain = world.time
		return ..(M)

	disposing()
		if(mob)
			mob.remove_stam_mod_max("abomination")
			mob.remove_stam_mod_regen("abomination")
		return ..()

	movement_delay()
		return 1

	onLife()
		//Bringing it more in line with how it was before it got broken (in a hilarious fashion)
		if (ruff_tuff_and_ultrabuff && !(mob.burning && prob(90))) //Are you a macho abomination or not?
			mob.paralysis = 0
			mob.weakened = 0
			mob.stunned = 0
			mob.drowsyness = 0
			mob.change_misstep_chance(-INFINITY)
			mob.slowed = 0
			mob.stuttering = 0
			changeling_super_heal_step(mob)

		if (drains_dna_on_life) //Do you continuously lose DNA points when in this form?
			var/datum/abilityHolder/changeling/C = mob.get_ability_holder(/datum/abilityHolder/changeling)

			if (C && C.points)
				if (last_drain + 30 <= world.time)
					C.points = max(0, C.points - 1)

				switch (C.points)
					if (-INFINITY to 0)
						mob.show_text("<I><B>We cannot hold this form!</B></I>", "red")
						mob.revert_from_horror_form()
					if (5)
						mob.show_text("<I><B>Our DNA stockpile is almost depleted!</B></I>", "red")
					if (10)
						mob.show_text("<I><B>We cannot maintain this form much longer!</B></I>", "red")
		return

	say_filter(var/message)
		return pick("We are one...", "Join with us...", "Sssssss...")

	say_verb()
		return "screeches"

	emote(var/act)
		var/message = null
		switch (act)
			if ("scream")
				if (mob.emote_allowed)
					mob.emote_allowed = 0
					message = "<span style=\"color:red\"><B>[mob] screeches!</B></span>"
					playsound(get_turf(mob), "sound/voice/creepyshriek.ogg", 60, 1)
					spawn (30)
						if (mob) mob.emote_allowed = 1
		return message

/datum/mutantrace/abomination/admin //This will not revert to human form
	drains_dna_on_life = 0

/datum/mutantrace/abomination/admin/weak //This also does not get any of the OnLife effects
	ruff_tuff_and_ultrabuff = 0

/datum/mutantrace/werewolf
	name = "werewolf"
	icon_state = "werewolf"
	human_compatible = 0
	uses_human_clothes = 0
	head_offset = -1
	var/original_name
	jerk = 1
	override_attack = 0
	r_limb_type_mutantrace = /obj/item/parts/human_parts/arm/right/werewolf
	l_limb_type_mutantrace = /obj/item/parts/human_parts/arm/left/werewolf
	ignore_missing_limbs = 0

	New()
		..()
		if (mob)
			mob.add_stam_mod_max("werewolf", 100) // Gave them a significant stamina boost, as they're melee-orientated (Convair880).
			mob.add_stam_mod_regen("werewolf", 25)

			src.original_name = mob.real_name
			mob.real_name = "werewolf"

			var/duration = 3000
			var/datum/ailment_data/disease/D = mob.find_ailment_by_type(/datum/ailment/disease/lycanthropy/)
			if(D)
				D.cycles++
				duration = rand(2000, 4000) * D.cycles
				spawn(duration)
					if(src)
						if (mob) mob.show_text("<b>You suddenly transform back into a human!</b>", "red")
						qdel(src)

	disposing()
		if (mob)
			mob.remove_stam_mod_max("werewolf")
			mob.remove_stam_mod_regen("werewolf")

			if (!isnull(src.original_name))
				mob.real_name = src.original_name

		return ..()

	movement_delay()
		return -1

	sight_modifier()
		if (mob && ismob(mob))
			mob.sight |= SEE_MOBS
			mob.see_in_dark = SEE_DARK_FULL
			mob.see_invisible = 2
		return

	// Werewolves (being a melee-focused role) are quite buff.
	onLife()
		if (mob && ismob(mob))
			if (mob.paralysis)
				mob.paralysis = max(0, mob.paralysis - 2)
			if (mob.weakened)
				mob.weakened = max(0, mob.weakened - 2)
			if (mob.stunned)
				mob.stunned = max(0, mob.stunned - 2)
			if (mob.drowsyness)
				mob.drowsyness = max(0, mob.stunned - 2)
			if (mob.misstep_chance)
				mob.change_misstep_chance(-10)
			if (mob.slowed)
				mob.slowed = max(0, mob.slowed -2)

		return

	say_verb()
		return "snarls"

	say_filter(var/message)
		return message

	emote(var/act)
		var/message = null
		switch(act)
			if("howl", "scream")
				if(mob.emote_allowed)
					mob.emote_allowed = 0
					message = "<span style=\"color:red\"><B>[mob] howls [pick("ominously", "eerily", "hauntingly", "proudly", "loudly")]!</B></span>"
					playsound(get_turf(mob), "sound/misc/werewolf_howl.ogg", 80, 0, 0, max(0.7, min(1.2, 1.0 + (30 - mob.bioHolder.age)/60)))
					spawn(30)
						mob.emote_allowed = 1
			if("burp")
				if(mob.emote_allowed)
					mob.emote_allowed = 0
					message = "<B>[mob]</B> belches."
					playsound(get_turf(mob), "sound/misc/burp_alien.ogg", 60, 1)
					spawn(10)
						mob.emote_allowed = 1
		return message

/datum/mutantrace/predator
	name = "predator"
	icon_state = "predator"
	human_compatible = 0
	jerk = 1
	override_attack = 0
	r_limb_type_mutantrace = /obj/item/parts/human_parts/arm/right/predator
	l_limb_type_mutantrace = /obj/item/parts/human_parts/arm/left/predator
	ignore_missing_limbs = 0

	// Gave them a minor stamina boost (Convair880).
	New(var/mob/living/carbon/human/M)
		M.add_stam_mod_max("predator", 50)
		M.add_stam_mod_regen("predator", 10)
		return ..(M)

	disposing()
		if(mob)
			mob.remove_stam_mod_max("predator")
			mob.remove_stam_mod_regen("predator")
		return ..()

	sight_modifier()
		mob.see_in_dark = SEE_DARK_FULL
		return

	movement_delay()
		return -1

	say_verb()
		return "snarls"

/datum/mutantrace/ithillid
	name = "ithillid"
	icon_state = "squid"
	allow_fat = 1
	jerk = 1
	override_attack = 0

	say_verb()
		return "glubs"

/datum/mutantrace/dwarf
	name = "dwarf"
	icon_state = "dwarf"
	head_offset = -3
	hand_offset = -2
	body_offset = -3
	override_eyes = 0
	override_hair = 0
	override_beard = 0
	override_skintone = 0
	override_attack = 0

/datum/mutantrace/monkey
	name = "monkey"
	icon = 'icons/mob/monkey.dmi'
	icon_state = "monkey"
	head_offset = -9
	hand_offset = -5
	body_offset = -7
//	uses_human_clothes = 0 // Guess they can keep that ability for now (Convair880).
	human_compatible = 0
	exclusive_language = 1
	voice_message = "chimpers"
	voice_name = "monkey"
	override_language = "monkey"
	understood_languages = list("english")
	var/sound_monkeyscream = 'sound/voice/monkey_scream.ogg'
	var/had_tablepass = 0
	var/table_hide = 0

	New(var/mob/living/carbon/human/M)
		if (M)
			if (M.flags & TABLEPASS)
				had_tablepass = 1
			else
				M.flags ^= TABLEPASS
		..()

	disposing()
		if(mob && !had_tablepass)
			mob.flags ^= TABLEPASS
		..()

	say_verb()
		return "chimpers"

	custom_attack(atom/target) // Fixed: monkeys can click-hide under every table now, not just the parent type. Also added beds (Convair880).
		if(istype(target, /obj/machinery/optable/))
			do_table_hide(target)
		if(istype(target, /obj/table/))
			do_table_hide(target)
		if(istype(target, /obj/stool/bed/))
			do_table_hide(target)
		return target.attack_hand(mob)

	proc
		do_table_hide(obj/target)
			step(mob, get_dir(mob, target))
			if (mob.loc == target.loc)
				if (table_hide)
					table_hide = 0
					mob.layer = MOB_LAYER
					mob.visible_message("[mob] crawls on top of [target]!")
				else
					table_hide = 1
					mob.layer = target.layer - 0.01
					mob.visible_message("[mob] hides under [target]!")

	emote(var/act)
		. = null
		var/muzzled = istype(mob.wear_mask, /obj/item/clothing/mask/muzzle)
		switch(act)
			if("scratch")
				if (!mob.restrained())
					. = "<B>The [mob.name]</B> scratches."
			if("whimper")
				if (!muzzled)
					. = "<B>The [mob.name]</B> whimpers."
			if("yawn")
				if (!muzzled)
					. = "<b>The [mob.name]</B> yawns."
			if("roar")
				if (!muzzled)
					. = "<B>The [mob.name]</B> roars."
			if("tail")
				. = "<B>The [mob.name]</B> waves \his tail."
			if("paw")
				if (!mob.restrained())
					. = "<B>The [mob.name]</B> flails \his paw."
			if("scretch")
				if (!muzzled)
					. = "<B>The [mob.name]</B> scretches."
			if("sulk")
				. = "<B>The [mob.name]</B> sulks down sadly."
			if("dance")
				if (!mob.restrained())
					. = "<B>The [mob.name]</B> dances around happily."
			if("roll")
				if (!mob.restrained())
					. = "<B>The [src.name]</B> rolls."
			if("gnarl")
				if (!muzzled)
					. = "<B>[mob]</B> gnarls and shows \his teeth.."
			if("jump")
				. = "<B>The [mob.name]</B> jumps!"
			if ("scream")
				if(mob.emote_allowed)
					if(!(mob.client && mob.client.holder))
						mob.emote_allowed = 0

					. = "<B>[mob]</B> screams!"
					playsound(get_turf(mob), src.sound_monkeyscream, 80, 0, 0, mob.get_age_pitch())

					spawn(50)
						if (mob)
							mob.emote_allowed = 1
			if ("fart")
				if(farting_allowed && mob.emote_allowed && (!mob.reagents || !mob.reagents.has_reagent("anti_fart")))
					mob.emote_allowed = 0
					var/fart_on_other = 0
					for(var/mob/living/M in mob.loc)
						if(M == src || !M.lying)
							continue
						. = "<span style=\"color:red\"><B>[mob]</B> farts in [M]'s face!</span>"
						fart_on_other = 1
						break
					if(!fart_on_other)
						switch(rand(1, 27))
							if(1) . = "<B>[mob]</B> farts. It smells like... bananas. Huh."
							if(2) . = "<B>[mob]</B> goes apeshit! Or at least smells like it."
							if(3) . = "<B>[mob]</B> releases an unbelievably foul fart."
							if(4) . = "<B>[mob]</B> chimpers out of its ass."
							if(5) . = "<B>[mob]</B> farts and looks incredibly amused about it."
							if(6) . = "<B>[mob]</B> unleashes the king kong of farts!"
							if(7) . = "<B>[mob]</B> farts and does a silly little dance."
							if(8) . = "<B>[mob]</B> farts gloriously."
							if(9) . = "<B>[mob]</B> plays the song of its people. With farts."
							if(10) . = "<B>[mob]</B> screeches loudly and wildly flails its arms in a poor attempt to conceal a fart."
							if(11) . = "<B>[mob]</B> clenches and bares its teeth, but only manages a sad squeaky little fart."
							if(12) . = "<B>[mob]</B> unleashes a chain of farts by beating its chest."
							if(13) . = "<B>[mob]</B> farts so hard a bunch of fur flies off its ass."
							if(14) . = "<B>[mob]</B> does an impression of a baboon by farting until its ass turns red."
							if(15) . = "<B>[mob]</B> farts out a choking, hideous stench!"
							if(16) . = "<B>[mob]</B> reflects on its captive life aboard a space station, before farting and bursting into hysterial laughter."
							if(17) . = "<B>[mob]</B> farts megalomaniacally."
							if(18) . = "<B>[mob]</B> rips a floor-rattling fart. Damn."
							if(19) . = "<B>[mob]</B> farts. What a damn dirty ape!"
							if(20) . = "<B>[mob]</B> farts. It smells like a nuclear engine. Not that you know what that smells like."
							if(21) . = "<B>[mob]</B> performs a complex monkey divining ritual. By farting."
							if(22) . = "<B>[mob]</B> farts out the smell of the jungle. The jungle smells gross as hell apparently."
							if(23) . = "<B>[mob]</B> farts up a methane monsoon!"
							if(24) . = "<B>[mob]</B> unleashes an utterly rancid stink from its ass."
							if(25) . = "<B>[mob]</B> makes a big goofy grin and farts loudly."
							if(26) . = "<B>[mob]</B> hovers off the ground for a moment using a powerful fart."
							if(27) . = "<B>[mob]</B> plays drums on its ass while farting."
					playsound(mob.loc, "sound/misc/poo2.ogg", 80, 0, 0, mob.get_age_pitch())

					mob.remove_stamina(STAMINA_DEFAULT_FART_COST)
					mob.stamina_stun()
	#ifdef DATALOGGER
					game_stats.Increment("farts")
	#endif
					spawn(10)
						mob.emote_allowed = 1
					for(var/mob/living/carbon/human/M in viewers(mob, null))
						if (!M.stat && M.get_brain_damage() >= 60)
							spawn(10)
								if(prob(20))
									switch(pick(1,2,3))
										if(1)
											M.say("[mob.name] made a fart!!")
										if(2)
											M.emote("giggle")
										if(3)
											M.emote("clap")

/datum/mutantrace/martian
	name = "martian"
	icon_state = "martian"
	human_compatible = 0
	uses_human_clothes = 0
	override_language = "martian"

/datum/mutantrace/retardedbaby
	name = "retarded alien baby"
	icon_state = "tardbaby"
	human_compatible = 0
	uses_human_clothes = 0
	jerk = 1
	New()
		..()
		if(mob)
			mob.real_name = pick("a", "ay", "ey", "eh", "e") + pick("li", "lee", "lhi", "ley", "ll") + pick("n", "m", "nn", "en")
			if(prob(50))
				mob.real_name = uppertext(mob.real_name)
			mob.bioHolder.AddEffect("clumsy")
			mob.take_brain_damage(80)
			mob.stuttering = 120
			mob.contract_disease(/datum/ailment/disability/clumsy,null,null,1)

/datum/mutantrace/premature_clone
	name = "premature clone"
	icon = 'icons/mob/human.dmi'
	icon_state = "mutant3"
	human_compatible = 1
	uses_human_clothes = 1
	override_hair = 0
	override_beard = 0
	override_skintone = 0

	New()
		..()
		if(mob && istype(mob.l_hand, /obj/item))
			var/obj/item/toDrop = mob.l_hand
			mob.u_equip(toDrop)
			if (toDrop)
				toDrop.layer = initial(toDrop.layer)
				toDrop.set_loc(mob.loc)

	say_verb()
		return "gurgles"

	//They only have one working hand :(
	custom_attack(atom/target)
		if (mob.hand)
			return null

		return target.attack_hand(mob)

	onDeath()
		spawn(20)
			if (mob)
				mob.visible_message("<span style=\"color:red\"><B>[mob]</B> starts convulsing violently!</span>", "You feel as if your body is tearing itself apart!")
				mob.weakened = max(15, mob.weakened)
				mob.make_jittery(1000)
				sleep(rand(20, 100))
				mob.gib()
		return

// some new simple gimmick junk

/datum/mutantrace/gross
	name = "mutilated"
	icon_state = "gross"
	override_attack = 0

	say_verb()
		return "shrieks"

/datum/mutantrace/faceless
	name = "humanoid"
	icon_state = "faceless"
	override_attack = 0

	say_verb()
		return "murmurs"

/datum/mutantrace/cyclops
	name = "cyclops"
	icon_state = "cyclops"
	override_hair = 0
	override_beard = 0
	override_attack = 0

/datum/mutantrace/roach
	name = "roach"
	icon_state = "roach"
	override_attack = 0

	say_verb()
		return "clicks"

	sight_modifier()
		mob.see_in_dark = SEE_DARK_HUMAN + 1
		mob.see_invisible = 1


/datum/mutantrace/xenomorph
	name = "This is the mark of lazy fucking coders if you can see this name."
	override_damage_detail = 1
	override_blood = 1
	override_fireover = 0
	override_human_stuff = 1
	override_attack = 1     // set to 1 to override the limb attack actions. Mutantraces may use the limb action within custom_attack(),
								// but they must explicitly specify if they're overriding via this var
	override_language = "xenoglish" // set to a language ID to replace the language of the human
	understood_languages = list() // additional understood languages (in addition to override_language if set, or english if not)
	allow_fat = 0			// whether fat icons/disabilities are used
	uses_special_head = 0	// unused
	human_compatible = 0	// if 1, allows human diseases and dna injectors to affect this mutantrace
	uses_human_clothes = 0	// if 0, can only wear clothes listed in an item's compatible_species var
	exclusive_language = 1	// if 1, only understood by others of this mutantrace
	voice_message = null	// overrides normal voice message if defined (and others don't understand us, ofc)
	voice_name = "Drone"
	jerk = 1				// Should robots arrest these by default?

	var/leaping = 0
	var/healrate = 1

	var/base_icon = 'icons/tg-goon-xenos/xeno.dmi'
	var/base_icon_state = "aliend"

	icon = 'icons/tg-goon-xenos/xeno.dmi'
	icon_state = "aliend_s"

	var/leap_icon = 'icons/tg-goon-xenos/xeno leap.dmi'
//	var/leap_icon_state = "aliend_leap"

	icon_head = null
	icon_beard = null

	head_offset = 0
	hand_offset = 0
	body_offset = 0

	r_limb_type_mutantrace = null // Should we get custom arms? Dispose() replaces them with normal human arms.
	l_limb_type_mutantrace = null
	ignore_missing_limbs = 1 // Replace both arms regardless of mob status (new and dispose).

	firevuln = 3
	brutevuln = 0.66

	var/plasma = 500
	var/maxPlasma = 500
	var/evoPlasma = 0
	var/evoTime = 100
	var/obj_destroy = 1//1 - 4 for how fast they break shit
	var/turf_destroy = 1

	var/stunDamage = 1

	var/had_tablepass = 0

	var/bigXeno = 0

	var/evoProgress = 0
	var/maxEvoProgress = 0

	var/sound_alienhiss1 = 'sound/voice/newalien/alienhiss1.ogg'
	var/sound_alienroar1 = 'sound/voice/newalien/alienroar1.ogg'
	var/sound_alienroar2 = 'sound/voice/newalien/alienroar2.ogg'
	var/sound_alienroar3 = 'sound/voice/newalien/alienroar3.ogg'

	var/sound_aliensnarl1 = 'sound/voice/newalien/aliensnarl1.ogg'
	var/sound_aliensnarl2 = 'sound/voice/newalien/aliensnarl2.ogg'

	var/sound_aliensnarlhit1 = 'sound/voice/newalien/aliensnarlhit1.ogg'

	var/sound_alienspeak1 = 'sound/voice/newalien/alienspeak.ogg'
	//tg sounds
	var/sound_alienscream0 = 'sound/voice/tg/hiss6.ogg'
//	var/sound_alienhiss = 'sound/voice/tg/hiss.ogg'
	var/sound_alienroar0 = 'sound/voice/tg/hiss5.ogg'
	//not tg

	var/pheromones = null
	var/xeno_light_on = 0

	emotes_allowed = list("hiss", "roar", "snarl", "deathgasp")
	//test
	New(var/mob/living/carbon/human/M)
		if (M)
			if (M.flags & TABLEPASS)
				had_tablepass = 1
			else
				M.flags ^= TABLEPASS
		..()

	disposing()
		if(mob && !had_tablepass)
			mob.flags ^= TABLEPASS
		..()

	say_verb()
		return "hisses"

	sight_modifier()
		mob.see_in_dark = SEE_DARK_HUMAN + 4
		mob.see_invisible = 3

	onLife()
		if (mob.layer != initial(mob.layer))//if they just evolved from a hiding larva we need to do this
			mob.layer = initial(mob.layer)
		if (evoProgress >= maxEvoProgress)
			evoProgress = maxEvoProgress

		else
			evoProgress++
			mob.ambient_xeno_update(0,0,0,0,1,0)

			if (evoProgress >= maxEvoProgress)
				mob.ambient_xeno_update(0,0,0,0,2,1)



		if (locate(/obj/xeno/hive/weeds) in mob.loc)
			if (plasma < maxPlasma)

				plasma += rand(10,20)

				if (plasma > maxPlasma)
					plasma = maxPlasma
					mob.ambient_xeno_update(1,0,0,0,0,1)
				else
					mob.ambient_xeno_update(1,0,0,0,0,0)

			else
				plasma = maxPlasma



			mob.HealBleeding(100)
			mob.HealDamage("All", healrate, healrate, healrate)

			if (mob.bleeding)
				mob.bleeding = 0

			mob.blood_volume += 10

			if (mob.blood_volume > 500)
				mob.blood_volume = 500

			mob.ambient_xeno_update(0,1,0,0,0,1)

			mob.updatehealth()

		update_pheromones()



	proc/onWeedEnter()
		if (plasma > maxPlasma)
			plasma = maxPlasma

	proc/onWeedExit()
		if (plasma > maxPlasma)
			plasma = maxPlasma

	proc/init_pheromones()
		if (pheromones == null)
			return
		else
			switch (pheromones)

				if ("Infuriate Monkeys")
					for (var/mob/living/carbon/human/npc/monkey/m in range(10, src.mob))
						for (var/mob/living/carbon/human/h in range(10, src.mob))
							if (ismonkey(m) && !ismonkey(h) && !isAlien(h) || prob(10) && ismonkey(m) && ismonkey(h) && !isAlien(h))
								m.was_harmed(h)


				if ("Heal Sisters")
					for (var/mob/living/carbon/human/h in range(10, src.mob))
						if (isAlien(h))
							h.mutantrace:plasma += rand(10,20)
							h.HealBleeding(100)
							h.HealDamage("All", h.mutantrace:healrate, h.mutantrace:healrate, h.mutantrace:healrate)
							if (h.bleeding)
								h.bleeding = 0

							h.blood_volume += 10

							if (h.blood_volume > 500)
								h.blood_volume = 500


				if ("Weaken Hosts")
					for (var/mob/living/carbon/human/h in range(10, src.mob))
						if (!isAlien(h))
							h.slowed = 1

				if ("Heal Nested Hosts")
					for (var/mob/living/carbon/human/h in range(10, src.mob))
						if (!isAlien(h))
							if (h.restrained() && istype(h.buckled, /obj/xeno/hive/nest))
								h.HealDamage("All", 5, 5, 5)

				//no initial effects for these
				if ("Expediate Hive Growth")
					return

				if ("Reinforce Hive")
					return



	proc/update_pheromones()
		if (pheromones == null)
			return
		else
			switch (pheromones)
				if ("Infuriate Monkeys")
					for (var/mob/living/carbon/human/npc/monkey/m in range(10, src.mob))
						for (var/mob/living/carbon/human/h in range(10, src.mob))
							if (ismonkey(m) && !ismonkey(h) && !isAlien(h) && prob(20) || prob(10) && ismonkey(m) && ismonkey(h) && !isAlien(h))
								m.was_harmed(h)//kek

				if ("Heal Sisters")
					for (var/mob/living/carbon/human/h in range(10, src.mob))
						if (isAlien(h))
							h.mutantrace:plasma += rand(10,20)
							h.HealBleeding(100)
							h.HealDamage("All", h.mutantrace:healrate, h.mutantrace:healrate, h.mutantrace:healrate)
							if (h.bleeding)
								h.bleeding = 0

							h.blood_volume += 10

							if (h.blood_volume > 500)
								h.blood_volume = 500


				if ("Weaken Hosts")
					for (var/mob/living/carbon/human/h in range(10, src.mob))
						if (!isAlien(h))
							h.slowed = 1
							if (prob(5))
								h.weakened += rand(4,5)
				if ("Heal Hosts")
					for (var/mob/living/carbon/human/h in range(10, src.mob))
						if (!isAlien(h))
							if (prob(10))
								h.HealDamage("All", 5, 5, 5)

				if ("Expediate Hive Growth")
					for (var/obj/xeno/hive/weeds/w in range(10, src.mob))
						if (w.is_node == 1)
							if (prob(1))
								if (!w.expediated)
									w.SurroundSpreadAll(1)
									w.expediated = 1

				if ("Reinforce Hive")
					for (var/obj/xeno/hive/wall/w in range(10, src.mob))
						if (prob(1))
							w.health += 1

					for (var/obj/xeno/hive/membrane/m in range(10, src.mob))
						if (prob(1))
							m.health += 1

	onDeath()
		for (var/mob/living/carbon/human/H in mobs)
			if (H.stat == 0 && isAlien(H))
				var/src_mob_area = src.mob.loc.loc
				if (istype(src.mob.loc, /atom/movable))
					src_mob_area = src.mob.loc.loc.loc
				boutput(H, "<span style = \"color:red\"><b>Hivemind: [src.mob] has been slain at [src_mob_area].</span></b>")
		icon_state = "[base_icon_state]_dead"
		var/mob/living/carbon/human/H  = src.mob
		H.xeno_light.disable()

		if (aghosted_xenos.Find(src.mob.client))
			aghosted_xenos -= src.mob.client
		return 0//don't override the death proc
	onRevive()
		for (var/mob/living/carbon/human/H in mobs)
			if (H.stat == 0 && isAlien(H))
				var/src_mob_area = src.mob.loc.loc
				if (istype(src.mob.loc, /atom/movable))
					src_mob_area = src.mob.loc.loc.loc
				boutput(H, "<span style = \"color:red\"><b>Hivemind: [src.mob] has been revived at [src_mob_area].</span></b>")
		var/mob/living/carbon/human/H = src.mob
		H.xeno_light.enable()
		icon_state = "[base_icon_state]_s"
		return 0//don't override the death proc
//	fve()


//	sight_modifier()
//		mob.see_in_dark = SEE_DARK_HUMAN + 1
	//	mob.see_invisible = 1

	emote(var/act)
		. = null
		switch(act)

			if ("hiss")
				if(mob.emote_allowed)
					if(!(mob.client && mob.client.holder))
						mob.emote_allowed = 0

					. = "<B>[mob]</B> hisses [pick("softly", "strangely", "menacingly", "eerily", "creepily", "scarily")]."
					playsound(get_turf(mob), src.sound_alienhiss1, 80, 0, 0, mob.get_age_pitch())

					spawn(50)
						if (mob)
							mob.emote_allowed = 1

			if ("roar")
				if(mob.emote_allowed)
					if(!(mob.client && mob.client.holder))
						mob.emote_allowed = 0

					. = "<B>[mob]</B> roars!"
					playsound(get_turf(mob), pick(src.sound_alienroar1, src.sound_alienroar2, src.sound_alienroar3), 80, 0, 0, mob.get_age_pitch())

					spawn(50)
						if (mob)
							mob.emote_allowed = 1

			if ("snarl")
				if(mob.emote_allowed)
					if(!(mob.client && mob.client.holder))
						mob.emote_allowed = 0

					. = "<B>[mob]</B> snarls [pick("softly", "strangely", "menacingly", "eerily", "creepily", "scarily")]."
					playsound(get_turf(mob), pick(src.sound_aliensnarl1, src.sound_aliensnarl2), 80, 0, 0, mob.get_age_pitch())

					spawn(50)
						if (mob)
							mob.emote_allowed = 1

			if ("deathgasp")
				if(mob.emote_allowed)
					if(!(mob.client && mob.client.holder))
						mob.emote_allowed = 0

					. = "<B>[mob]</B> falls to the ground limply, uttering a final, gutteral screech from its mouth..."
					playsound(get_turf(mob), src.sound_alienscream0, 80, 0, 0, mob.get_age_pitch())

					spawn(50)
						if (mob)
							mob.emote_allowed = 1




	custom_attack(atom/target)
//		if (istype(target, /obj/xeno))
	//		target.
		var/was_window = 0
		var/was_grille = 0
		var/was_item = 0
		var/was_door = 0
		var/was_light = 0
		var/was_plasticflaps = 0
		var/was_displaycase = 0

		if (istype(target, /obj/window))
			was_window = 1

		if (istype(target, /obj/grille))
			was_grille = 1

		if (istype(target, /obj/item))
			was_item = 1

		if (istype(target, /obj/machinery/door))
			was_door = 1

		if (istype(target, /obj/plasticflaps))
			was_plasticflaps = 1

		if (istype(target, /obj/machinery/light))
			was_light = 1

		if (istype(target, /obj/displaycase))
			was_displaycase = 1


		if (isobj(target))
			if (istype(target, /obj/item/organ))
				if (target:xeno_devour(mob))
					return 1
			if (istype(target, /obj/decal/cleanable/blood/gibs))
				if (target.attack_hand(mob))
					return 1
			if (istype(target, /obj/critter))
				target.attack_hand(mob)
				return 1
			if (was_item && target == mob.r_hand || was_item && target == mob.l_hand)
				return 0
			if (istype(target, /obj/item/xeno))
				return target.attack_hand(mob)
			if (mob.smash_through(target, list("window", "grille", "door", "table", "stool", "rack", "machinery", "plastic flaps", "clothing", "displaycase", "fitness", "morgue", "crematorium", "storage", "loudspeaker", "reagentdispenser", "shrub", "all unanchored dense objects", "small stuff", "medium stuff", "large stuff")))

				if (was_light || was_displaycase && !was_window)
					playsound(mob.loc, "sound/effects/Glasshit.ogg", 75, 1)
					if (!target)//window has its own sound
						playsound(mob.loc, pick(sounds_shatter), 75, 1)
					return

				if (was_grille)
					playsound(mob.loc, "sound/effects/grillehit.ogg", 75, 1)
					return

				if (was_item || was_plasticflaps)
					playsound(mob.loc, "sound/weapons/slashcut.ogg", 75, 1)
					return

				if (was_door)
					return

				playsound(mob.loc, "sound/effects/bang.ogg", 75, 1)
				return
			else
				return target.attack_hand(mob)

		else if (isturf(target))
			if (mob.smash_through(target, list("wall")))
				playsound(mob.loc, "sound/effects/bang.ogg", 75, 1)
				return
			else
				return target.attack_hand(mob)

		else if (ismob(target))
			return target.attack_hand(mob)

	proc/get_object_destroy_bonus_chance()
		if (obj_destroy <= 1)
			return 0
		else
			return obj_destroy * 10

	proc/get_turf_destroy_bonus_chance()
		if (turf_destroy <= 1)
			return 0
		else
			return turf_destroy * 10

/*
	proc/put_in_hand_xeno(obj/xeno/A, hand)
		if (!istype(A))
			return 0
		if (isnull(hand))
			if (src.mob.put_in_hand_xeno(A, src.mob.hand))
				return 1
			if (src.mob.put_in_hand_xeno(A, !src.mob.hand))
				return 1
			return 0
		else
			if (hand)
				if (!src.mob.l_hand)
					if (src.mob.limbs && (!src.mob.limbs.l_arm || istype(src.mob.limbs.l_arm, /obj/item/parts/human_parts/arm/left/item)))
						return 0
					src.mob.l_hand = A
					A.set_loc(src.mob)
					src.mob.update_inhands()
			//		mob.hud.add_object(A, HUD_LAYER+2, mob.ui_lhand)
					return 1
				else
					return 0
			else
				if (!src.mob.r_hand)
					if (src.mob.limbs && (!src.mob.limbs.r_arm || istype(src.mob.limbs.r_arm, /obj/item/parts/human_parts/arm/right/item)))
						return 0
					src.mob.r_hand = A
					A.set_loc(src.mob)
					src.mob.update_inhands()
			//		mob.hud.add_object(A, HUD_LAYER+2, mob.ui_rhand)
					return 1
				else
					return 0

	proc/drop_xeno(obj/xeno/A, hand)
		if (!istype(A))
			return 0
		if (isnull(hand))
			return 0
		else
			if (hand)
				if (src.mob.l_hand == hand)
					var/obj/xeno/ayy = src.mob.l_hand
					ayy.set_loc(get_step(src.mob, src.mob.dir))
					src.mob.update_inhands()
					mob.hud.remove_object(ayy)
					return 1
				else
					var/obj/xeno/ayy = src.mob.r_hand
					ayy.set_loc(get_step(src.mob, src.mob.dir))
					src.mob.update_inhands()
					mob.hud.remove_object(ayy)
					return 1
*/
	proc/setActionState(var/action)

		switch (action)
			if ("")
				icon_state = "[base_icon_state]_s"
			if ("die")
				icon_state = "[base_icon_state]_dead"
			if ("knockout")
				icon_state = "[base_icon_state]_unconscious"
			if ("husk")
				icon_state = "[base_icon_state]_husked"

	proc/leap()
		mob.update_xeno_icon(1)
	proc/stop_leaping()
		mob.update_xeno_icon(0)


/datum/mutantrace/xenomorph/larva
	plasma = 10
	maxPlasma = 10//if this is 0, you divide by 0. Don't divide by 0.
	evoPlasma = 0
	evoTime = 50
	firevuln = 10
	brutevuln = 5
	obj_destroy = 0
	turf_destroy = 0

	healrate = 1

	override_fireover = 1
	base_icon = 'icons/tg-goon-xenos/xeno.dmi'
	base_icon_state = "larva1"
	icon_state = "larva1"

	bonus_damage_first = 0
	bonus_damage_second = 0

	evoProgress = 0
	maxEvoProgress = 100

	var/hiding = 0

	New(var/mob/living/carbon/human/M)
		if(ishuman(M))
			src.mob = M
			var/list/obj/item/clothing/restricted = list(mob.w_uniform, mob.shoes, mob.wear_suit)
			for(var/obj/item/clothing/W in restricted)
				if (istype(W,/obj/item/clothing))
					if(W.compatible_species.Find(src.name) || (src.human_compatible && W.compatible_species.Find("human")))
						continue
					mob.u_equip(W)
					boutput(mob, "<span style=\"color:red\"><B>You can no longer wear the [W.name] in your current state!</B></span>")
					if (W)
						W.set_loc(mob.loc)
						W.dropped(mob)
						W.layer = initial(W.layer)
			M.image_eyes.pixel_y = src.head_offset
			M.image_cust_one.pixel_y = src.head_offset
			M.image_cust_two.pixel_y = src.head_offset
			M.image_cust_three.pixel_y = src.head_offset

			// Replacement for custom_attack() of several mutantraces, which used an entire copy of
			// pre-stamina melee code. They do the same stuff with more flexible limb datums (Convair880).
			if (!isnull(src.r_limb_type_mutantrace))
				if (M.limbs.r_arm || src.ignore_missing_limbs == 1)
					var/obj/item/parts/human_parts/arm/limb = new src.r_limb_type_mutantrace(M)
					if (limb && istype(limb))
						qdel(M.limbs.r_arm)
						limb.quality = 0.5
						M.limbs.r_arm = limb
						limb.holder = M
						limb.remove_stage = 0

			if (!isnull(src.l_limb_type_mutantrace))
				if (M.limbs.l_arm || src.ignore_missing_limbs == 1)
					var/obj/item/parts/human_parts/arm/limb2 = new src.l_limb_type_mutantrace(M)
					if (limb2 && istype(limb2))
						qdel(M.limbs.l_arm)
						limb2.quality = 0.5
						M.limbs.l_arm = limb2
						limb2.holder = M
						limb2.remove_stage = 0

			M.update_face()
			M.update_body()

			spawn (25) // Don't remove.
				if (M && M.organHolder && M.organHolder.skull)
					M.assign_gimmick_skull() // For predators (Convair880).

			if (istype(src, /datum/mutantrace/xenomorph))
				src.mob.full_heal()
				src.mob.updatehealth()

		else
			src.dispose()
		return

	disposing()
		..()

	say_verb()
		return "hisses"


	onLife()
		..()
		if (hiding)
			mob.layer = HIDING_MOB_LAYER
		else
			mob.layer = initial(mob.layer)
	/*
		evoProgress++
		if (evoProgress > maxEvoProgress)
			evoProgress = maxEvoProgress

		if (locate(/obj/xeno/hive/weeds) in mob.loc)
			plasma += rand(10,20)
			if (plasma > maxPlasma)
				plasma = maxPlasma
			mob.see_in_dark = SEE_DARK_HUMAN + 5

			mob.HealBleeding(100)
			mob.HealDamage("All", 1, 1, 1)
		else
			mob.see_in_dark = SEE_DARK_HUMAN
			*/

//	onMove()


//	sight_modifier()
//		mob.see_in_dark = SEE_DARK_HUMAN + 1
	//	mob.see_invisible = 1

	emote(var/act)
		. = null
		switch(act)
			if ("deathgasp")
				if (mob.stat == 0)
					return
				if(mob.emote_allowed)
					if(!(mob.client && mob.client.holder))
						mob.emote_allowed = 0

					. = "<B>[mob]</B> falls to the ground limply, uttering a final, gutteral screech from its mouth..."
					if (!isAlienHugger(src.mob))
						playsound(get_turf(mob), src.sound_alienscream0, 80, 0, 0, mob.get_age_pitch())
					else
						hugger_death_sound(src.mob)

					spawn(50)
						if (mob)
							mob.emote_allowed = 1
	onDeath()
		..()
		icon_state = "larva1_dead"
		return 0//don't override the death proc
	onRevive()
		..()
		icon_state = "larva1"
		return 0

	custom_attack(atom/target)

		if (isobj(target))
			if (istype(target, /obj/item/organ))
				if (target:xeno_devour(mob))
					return 1
			if (istype(target, /obj/decal/cleanable/blood/gibs))
				if (target.attack_hand(mob))
					return 1

			return 0

		else if (isturf(target))
			return

		else if (ismob(target))
			return

/datum/mutantrace/xenomorph/larva/facehugger

	plasma = 10
	maxPlasma = 10
	evoTime = 100
	firevuln = 100
	brutevuln = 30

	healrate = 1

	base_icon = 'icons/tg-goon-xenos/xeno.dmi'
	base_icon_state = "facehugger"
	icon_state = "facehugger"

	bonus_damage_first = 0
	bonus_damage_second = 0

	evoProgress = 0
	maxEvoProgress = -1

	stamina_divider = 1

	proc/facehug(var/mob/living/carbon/human/target)
		var/health_deficiency = 0
		var/force = 0
		if (mob.health < 80)
			health_deficiency = 5
		if (mob.health < 50)
			health_deficiency = 10
		if (mob.health < 20)
			health_deficiency = 15

		if (target.lying || target.weakened || target.stunned || target.paralysis)
			health_deficiency = -80
			force = 1

		if (target.stat == 2)
			boutput(src.mob, "<span style = \"color:red\"><b>This host is already dead.</span></b>")
			return 0

		if (prob(20-health_deficiency) || force)
			if (!ishuman(target))
				return 0

			for (var/datum/ailment_data/am in target.ailments)//dead people still burst,
				//they just can't be facehugged.
				if (istype(am.master, /datum/ailment/parasite/alien_larva))
					boutput(src.mob, "<span style = \"color:red\"><b>This host is already infected.</span></b>")
					return 0

			if (istype(target.head, /obj/item/clothing/head/helmet))
				if (prob(target.head.armor_value_melee * 10 > 85 ? 85 : target.head.armor_value_melee * 10))
					boutput(src.mob, "<span style = \"color:red\"><b>[src.mob] bounces off of [target]'s helmet!</span></b>")
					if (prob(target.head.armor_value_melee *3))
						boutput(src.mob, "<span style = \"color:red\"><b>[src.mob] is smashed by [target]'s helmet!</span></b>")
						var/mobloc = src.mob.loc
						src.mob.ghostize()
						for (var/mob/m in mobloc)
							if (isAlien(m) && istype(m:mutantrace, /datum/mutantrace/xenomorph/larva/facehugger))
								qdel(m)

						var/obj/item/xeno/facehugger/f = new/obj/item/xeno/facehugger(mobloc)
						f.death(0)
					return

			if (istype(target.wear_mask, /obj/item/clothing/mask))
				if (prob(target.wear_mask.armor_value_melee * 10 > 70 ? 70 : target.wear_mask.armor_value_melee * 10))
					boutput(src.mob, "<span style = \"color:red\"><b>[src.mob] bounces off of [target]'s mask!</span></b>")
					if (prob(target.wear_mask.armor_value_melee * 1))//I mean it's just a mask
						boutput(src.mob, "<span style = \"color:red\"><b>[src.mob] is smashed by [target]'s mask!</span></b>")
						var/mobloc = src.mob.loc
						src.mob.ghostize()
						for (var/mob/m in mobloc)
							if (isAlien(m) && istype(m:mutantrace, /datum/mutantrace/xenomorph/larva/facehugger))
								qdel(m)

						var/obj/item/xeno/facehugger/f = new/obj/item/xeno/facehugger(mobloc)
						f.death(0)
					return


			target.visible_message("<span style = \"color:red\"><b>[target] is facehugged by [src.mob]!</b></span>")

			hugger_hug_sound(target)

			for (var/mob/living/carbon/human/H in mobs)
				if (H.stat == 0 && isAlien(H))
					boutput(H, "<span style = \"color:red\"><b>Hivemind: [src.mob] has successfully facehugged a host at [target.loc.loc].</span></b>")

			target.force_equip(null, target.slot_wear_mask)
			target.force_equip(new/obj/item/clothing/mask/alien, target.slot_wear_mask)
			target.force_equip(null, target.head)
		//	spawn(rand(100,200))
			//	target.contract_disease(/datum/ailment/parasite/alien_larva, null, null, 1)
			target.contract_disease(/datum/ailment/parasite/alien_larva, null, null, 1)
			target.weakened += 10
			target.stunned += 10

			var/mobloc = src.mob.loc
			src.mob.ghostize()
			for (var/mob/m in mobloc)
				if (isAlien(m) && istype(m:mutantrace, /datum/mutantrace/xenomorph/larva/facehugger))
					qdel(m)//prevents src's onDeath() from being called

			for (var/mob/m in mobloc)
				if (isobserver(m))
					target.parasitoid_priority = m

		// ghost hugger	del W

			spawn (rand(70,100))
				if (target.wear_mask)
					target.visible_message("<span style = \"color:red\"><b>The facehugger on [target]'s face shrivels up and dies.</span></b>")
					var/obj/item/xeno/facehugger/f = new/obj/item/xeno/facehugger(target.loc)
					f.death(1)
					target.u_equip(/obj/item/clothing/mask/alien)
					target.update_clothing()
		else
			src.mob.visible_message("<span style = \"color:red\"><b>[src.mob] tries to facehug [target], but fails!</span></b>")
			target.remove_stamina(1)

	custom_attack(atom/target)

		if (isobj(target))
			return

		else if (isturf(target))
			return

		else if (ismob(target))
			if (ishuman(target) && !target:mutantrace)
				facehug(target)
	onDeath()
		..()
		icon_state = "facehugger_dead"
		return 0//don't override the death proc
	onRevive()
		..()
		icon_state = "facehugger"
		return 0

/datum/mutantrace/xenomorph/drone
	plasma = 500
	maxPlasma = 500
	evoPlasma = 0
	evoTime = 220
	healrate = 2
	firevuln = 3
	brutevuln = 0.66
	obj_destroy = 3
	turf_destroy = 3

	base_icon = 'icons/tg-goon-xenos/xeno.dmi'
	base_icon_state = "aliend"
	icon_state = "aliend_s"


	bonus_damage_first = 10
	bonus_damage_second = 15

	evoProgress = 0
	maxEvoProgress = 500//this should be in actual seconds, not tenth seconds, as it's called
	//on life

	stamina_divider = 2

/datum/mutantrace/xenomorph/sentinel
	plasma = 300
	maxPlasma = 300
	evoPlasma = 0
	healrate = 3
	evoTime = 350
	firevuln = 2.5
	brutevuln = 0.5
	obj_destroy = 1
	turf_destroy = 1


	bonus_damage_first = 12
	bonus_damage_second = 17

	evoProgress = 0
	maxEvoProgress = 700//this should be in actual seconds, not tenth seconds, as it's called
	//on life

	stamina_divider = 3

	base_icon = 'icons/tg-goon-xenos/xeno.dmi'
	base_icon_state = "aliens"
	icon_state = "aliens_s"

/datum/mutantrace/xenomorph/warrior
	plasma = 600
	maxPlasma = 600
	evoPlasma = 0
	evoTime = 500
	firevuln = 2
	healrate = 5
	brutevuln = 0.4
	obj_destroy = 1
	turf_destroy = 1


	bonus_damage_first = 25//was 16
	bonus_damage_second = 35//was 21

	evoProgress = 0
	maxEvoProgress = -1//this should be in actual seconds, not tenth seconds, as it's called
	//on life

	stamina_divider = 5

	base_icon = 'icons/tg-goon-xenos/xeno.dmi'
	base_icon_state = "alienh"
	icon_state = "alienh_s"

/datum/mutantrace/xenomorph/praetorian
	plasma = 1000
	maxPlasma = 1000
	evoPlasma = 0
	evoTime = 500
	firevuln = 2.3
	healrate = 7
	brutevuln = 0.3
	obj_destroy = 2
	turf_destroy = 2
	bigXeno = 1


	override_fireover = 1

	evoProgress = 0
	maxEvoProgress = 1000//this should be in actual seconds, not tenth seconds, as it's called
	//on life

	bonus_damage_first = 15
	bonus_damage_second = 20

	head_offset = -16
	hand_offset = -16
	body_offset = -16

	pixelXoffset = -16

	stamina_divider = 15

	base_icon = 'icons/tg-goon-xenos/big xeno.dmi'
	base_icon_state = "alienp"

	icon = 'icons/tg-goon-xenos/big xeno.dmi'
	icon_state = "alienp_s"
	leap_icon = 'icons/tg-goon-xenos/xeno leap.dmi'

	New(var/mob/living/carbon/human/M)
		if(ishuman(M))
			src.mob = M
			var/list/obj/item/clothing/restricted = list(mob.w_uniform, mob.shoes, mob.wear_suit)
			for(var/obj/item/clothing/W in restricted)
				if (istype(W,/obj/item/clothing))
					if(W.compatible_species.Find(src.name) || (src.human_compatible && W.compatible_species.Find("human")))
						continue
					mob.u_equip(W)
					boutput(mob, "<span style=\"color:red\"><B>You can no longer wear the [W.name] in your current state!</B></span>")
					if (W)
						W.set_loc(mob.loc)
						W.dropped(mob)
						W.layer = initial(W.layer)
			M.image_eyes.pixel_y = src.head_offset
			M.image_cust_one.pixel_y = src.head_offset
			M.image_cust_two.pixel_y = src.head_offset
			M.image_cust_three.pixel_y = src.head_offset

			// Replacement for custom_attack() of several mutantraces, which used an entire copy of
			// pre-stamina melee code. They do the same stuff with more flexible limb datums (Convair880).
			if (!isnull(src.r_limb_type_mutantrace))
				if (M.limbs.r_arm || src.ignore_missing_limbs == 1)
					var/obj/item/parts/human_parts/arm/limb = new src.r_limb_type_mutantrace(M)
					if (limb && istype(limb))
						qdel(M.limbs.r_arm)
						limb.quality = 0.5
						M.limbs.r_arm = limb
						limb.holder = M
						limb.remove_stage = 0

			if (!isnull(src.l_limb_type_mutantrace))
				if (M.limbs.l_arm || src.ignore_missing_limbs == 1)
					var/obj/item/parts/human_parts/arm/limb2 = new src.l_limb_type_mutantrace(M)
					if (limb2 && istype(limb2))
						qdel(M.limbs.l_arm)
						limb2.quality = 0.5
						M.limbs.l_arm = limb2
						limb2.holder = M
						limb2.remove_stage = 0

			M.update_face()
			M.update_body()

			spawn (25) // Don't remove.
				if (M && M.organHolder && M.organHolder.skull)
					M.assign_gimmick_skull() // For predators (Convair880).

			if (istype(src, /datum/mutantrace/xenomorph))
				src.mob.full_heal()
				src.mob.updatehealth()

		else
			src.dispose()
		return

/datum/mutantrace/xenomorph/drone/queen
	plasma = 1000
	maxPlasma = 1000
	evoPlasma = 0
	evoTime = 500
	firevuln = 1.5
	brutevuln = 0.25
	obj_destroy = 3
	turf_destroy = 3
	healrate = 10
	bigXeno = 1

	evoProgress = 0
	maxEvoProgress = -1//this should be in actual seconds, not tenth seconds, as it's called
	//on life

	override_fireover = 1

	bonus_damage_first = 11
	bonus_damage_second = 16

	stamina_divider = 20

	head_offset = -12
	hand_offset = -12
	body_offset = -12

	pixelXoffset = -12

	New(var/mob/living/carbon/human/M)
		if(ishuman(M))
			src.mob = M
			var/list/obj/item/clothing/restricted = list(mob.w_uniform, mob.shoes, mob.wear_suit)
			for(var/obj/item/clothing/W in restricted)
				if (istype(W,/obj/item/clothing))
					if(W.compatible_species.Find(src.name) || (src.human_compatible && W.compatible_species.Find("human")))
						continue
					mob.u_equip(W)
					boutput(mob, "<span style=\"color:red\"><B>You can no longer wear the [W.name] in your current state!</B></span>")
					if (W)
						W.set_loc(mob.loc)
						W.dropped(mob)
						W.layer = initial(W.layer)
			M.image_eyes.pixel_y = src.head_offset
			M.image_cust_one.pixel_y = src.head_offset
			M.image_cust_two.pixel_y = src.head_offset
			M.image_cust_three.pixel_y = src.head_offset

			// Replacement for custom_attack() of several mutantraces, which used an entire copy of
			// pre-stamina melee code. They do the same stuff with more flexible limb datums (Convair880).
			if (!isnull(src.r_limb_type_mutantrace))
				if (M.limbs.r_arm || src.ignore_missing_limbs == 1)
					var/obj/item/parts/human_parts/arm/limb = new src.r_limb_type_mutantrace(M)
					if (limb && istype(limb))
						qdel(M.limbs.r_arm)
						limb.quality = 0.5
						M.limbs.r_arm = limb
						limb.holder = M
						limb.remove_stage = 0

			if (!isnull(src.l_limb_type_mutantrace))
				if (M.limbs.l_arm || src.ignore_missing_limbs == 1)
					var/obj/item/parts/human_parts/arm/limb2 = new src.l_limb_type_mutantrace(M)
					if (limb2 && istype(limb2))
						qdel(M.limbs.l_arm)
						limb2.quality = 0.5
						M.limbs.l_arm = limb2
						limb2.holder = M
						limb2.remove_stage = 0

			M.update_face()
			M.update_body()

			spawn (25) // Don't remove.
				if (M && M.organHolder && M.organHolder.skull)
					M.assign_gimmick_skull() // For predators (Convair880).

			if (istype(src, /datum/mutantrace/xenomorph))
				src.mob.full_heal()
				src.mob.updatehealth()

		else
			src.dispose()
		return

	disposing()
		..()



	base_icon = 'icons/tg-goon-xenos/big xeno.dmi'
	base_icon_state = "alienq"

	icon = 'icons/tg-goon-xenos/big xeno.dmi'
	icon_state = "alienq_s"
	leap_icon = 'icons/tg-goon-xenos/xeno leap.dmi'

/datum/mutantrace/xenomorph/drone/queen/empress
	plasma = 10000
	maxPlasma = 10000
	evoPlasma = 0
	evoTime = 500
	firevuln = 1.2
	brutevuln = 0.2
	obj_destroy = 4
	turf_destroy = 4
	healrate = 20
	bigXeno = 1

	override_fireover = 1

	bonus_damage_first = 25
	bonus_damage_second = 35//same as warrior

	evoProgress = 0
	maxEvoProgress = -1//this should be in actual seconds, not tenth seconds, as it's called
	//on life

	stamina_divider = 25

	head_offset = -12
	hand_offset = -12
	body_offset = -12

	pixelXoffset = -12

	New(var/mob/living/carbon/human/M)
		..()
		if(ishuman(M))
			src.mob = M
			var/list/obj/item/clothing/restricted = list(mob.w_uniform, mob.shoes, mob.wear_suit)
			for(var/obj/item/clothing/W in restricted)
				if (istype(W,/obj/item/clothing))
					if(W.compatible_species.Find(src.name) || (src.human_compatible && W.compatible_species.Find("human")))
						continue
					mob.u_equip(W)
					boutput(mob, "<span style=\"color:red\"><B>You can no longer wear the [W.name] in your current state!</B></span>")
					if (W)
						W.set_loc(mob.loc)
						W.dropped(mob)
						W.layer = initial(W.layer)
			M.image_eyes.pixel_y = src.head_offset
			M.image_cust_one.pixel_y = src.head_offset
			M.image_cust_two.pixel_y = src.head_offset
			M.image_cust_three.pixel_y = src.head_offset

			// Replacement for custom_attack() of several mutantraces, which used an entire copy of
			// pre-stamina melee code. They do the same stuff with more flexible limb datums (Convair880).
			if (!isnull(src.r_limb_type_mutantrace))
				if (M.limbs.r_arm || src.ignore_missing_limbs == 1)
					var/obj/item/parts/human_parts/arm/limb = new src.r_limb_type_mutantrace(M)
					if (limb && istype(limb))
						qdel(M.limbs.r_arm)
						limb.quality = 0.5
						M.limbs.r_arm = limb
						limb.holder = M
						limb.remove_stage = 0

			if (!isnull(src.l_limb_type_mutantrace))
				if (M.limbs.l_arm || src.ignore_missing_limbs == 1)
					var/obj/item/parts/human_parts/arm/limb2 = new src.l_limb_type_mutantrace(M)
					if (limb2 && istype(limb2))
						qdel(M.limbs.l_arm)
						limb2.quality = 0.5
						M.limbs.l_arm = limb2
						limb2.holder = M
						limb2.remove_stage = 0

			M.update_face()
			M.update_body()

			spawn (25) // Don't remove.
				if (M && M.organHolder && M.organHolder.skull)
					M.assign_gimmick_skull() // For predators (Convair880).

		else
			src.dispose()
		return

	disposing()
		..()

	base_icon = 'icons/tg-goon-xenos/big xeno.dmi'
	base_icon_state = "alienq"

	icon = 'icons/tg-goon-xenos/big xeno.dmi'
	icon_state = "alienq_s"
	leap_icon = 'icons/tg-goon-xenos/xeno leap.dmi'

/datum/mutantrace/xenomorph/drone/l
	icon = 'icons/tg-goon-xenos/xeno leap.dmi'
	icon_state = "aliend_leap"
	base_icon = 'icons/tg-goon-xenos/xeno leap.dmi'
	base_icon_state = "aliend_leap"

/datum/mutantrace/xenomorph/sentinel/l
	icon = 'icons/tg-goon-xenos/xeno leap.dmi'
	icon_state = "aliens_leap"
	base_icon = 'icons/tg-goon-xenos/xeno leap.dmi'
	base_icon_state = "aliens_leap"
/datum/mutantrace/xenomorph/warrior/l
	icon = 'icons/tg-goon-xenos/xeno leap.dmi'
	icon_state = "alienw_leap"
	base_icon = 'icons/tg-goon-xenos/xeno leap.dmi'
	base_icon_state = "alienw_leap"