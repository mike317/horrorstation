/obj/screen/ability/xenomorph
	clicked(params)
		if (!ishuman(owner.holder.owner) || !owner.holder.owner:mutantrace || !istype(owner.holder.owner:mutantrace, /datum/mutantrace/xenomorph))
			return 0	//this obj's owner, an abilityHolder, then that holder's owner, the mob itself
		var/datum/targetable/xenomorph/spell = owner
		var/datum/abilityHolder/holder = owner.holder

		if (!istype(spell))
			return
		if (!spell.holder)
			return

		if(params["shift"] && params["ctrl"])
			if(owner.waiting_for_hotkey)
				holder.cancel_action_binding()
				return
			else
				owner.waiting_for_hotkey = 1
				src.updateIcon()
				boutput(usr, "<span class='game xenobold'>Please press a number to bind this power to...</span>")
				return

		if (!isturf(owner.holder.owner.loc) && !spell.can_use_in_container)
			boutput(owner.holder.owner, "<span class='game xenobold'>You cannot use this power here.</span>")
			return
		if (spell.targeted && usr:targeting_spell == owner)
			usr:targeting_spell = null
			usr.update_cursor()
			return
		if (spell.targeted)
			if (world.time < spell.last_cast)
				return
			owner.holder.owner.targeting_spell = owner
			owner.holder.owner.update_cursor()
		else
			spawn
				spell.handleCast()


/datum/abilityHolder/xenomorph
	tabName = "Xenomorph"

	New(var/mob/living/M)
		..()

	onAbilityStat()
		..()


/datum/targetable/xenomorph
	icon = 'icons/mob/alien_ui.dmi'
	icon_state = "genericskill"
	cooldown = 0
	last_cast = 0
	var/can_use_in_container = 0
	preferred_holder_type = /datum/abilityHolder/xenomorph

	New()
		var/obj/screen/ability/xenomorph/X = new /obj/screen/ability/xenomorph(null)
		X.icon = src.icon
		X.icon_state = src.icon_state
		X.owner = src
		X.name = src.name
		X.desc = src.desc
		src.object = X

	updateObject()
		..()
		if (!src.object)
			src.object = new /obj/screen/ability/xenomorph()
			object.icon = src.icon
			object.owner = src
		if (src.last_cast > world.time)
			var/pttxt = ""
			if (pointCost)
				pttxt = " \[[pointCost]\]"
			object.name = "[src.name][pttxt] ([round((src.last_cast-world.time)/10)])"
			object.icon_state = src.icon_state + "_cd"
		else
			var/pttxt = ""
			if (pointCost)
				pttxt = " \[[pointCost]\]"
			object.name = "[src.name][pttxt]"
			object.icon_state = src.icon_state

	proc/incapacitationCheck()
		var/mob/living/M = holder.owner
		/*
		var/datum/abilityHolder/xenomorph/H = holder
		if (istype(H) && H.in_fakedeath)
			return 1
			*/
		return M.stat || M.paralysis

	castcheck()
		if (!ishuman(holder.owner) || !holder.owner:mutantrace || !istype(holder.owner:mutantrace, /datum/mutantrace/xenomorph))
			return 0
		if (incapacitationCheck())
			boutput(holder.owner, ("<span class='game xenobold'>You cannot use this power while incapacitated.</span>"))
			return 0
		var/mob/living/carbon/human/H = holder.owner
		if (istype(H))
			return 1
		return 0

	cast(atom/target)
		. = ..()
		actions.interrupt(holder.owner, INTERRUPT_ACT)

	Stat()
		..()