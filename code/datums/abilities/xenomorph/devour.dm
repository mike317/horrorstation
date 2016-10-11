/*
/datum/action/bar/icon/xenomorphDevour
	duration = 50
	interrupt_flags = INTERRUPT_MOVE | INTERRUPT_ACT | INTERRUPT_STUNNED | INTERRUPT_ACTION
	id = "abom_devour"
	icon = 'icons/mob/critter_ui.dmi'
	icon_state = "devour_over"
	var/mob/living/target
	var/datum/targetable/xenomorph/devour/devour

	New(Target, Devour)
		target = Target
		devour = Devour
		..()

	onUpdate()
		..()

		if(get_dist(owner, target) > 1 || target == null || owner == null || !devour)
			interrupt(INTERRUPT_ALWAYS)
			return

		var/mob/ownerMob = owner
		var/obj/item/grab/G = ownerMob.equipped()

		if (!istype(G) || G.affecting != target || G.state < 1)
			if (!ownerMob.pulling)
				interrupt(INTERRUPT_ALWAYS)
				return

	onStart()
		..()
		if(get_dist(owner, target) > 1 || target == null || owner == null || !devour)
			interrupt(INTERRUPT_ALWAYS)
			return

		var/mob/ownerMob = owner
		ownerMob.show_message("<span style=\"color:blue\">You must hold still for a moment...</span>", 1)

	onEnd()
		..()

		var/mob/ownerMob = owner
		if(owner && ownerMob && target && get_dist(owner, target) <= 1 && devour)
			boutput(ownerMob, "<span style=\"color:blue\">You devour [target]!</span>")
			ownerMob.visible_message(text("<span style=\"color:red\"><B>[ownerMob] hungrily devours [target]!</B></span>"))
		//	playsound(ownerMob.loc, 'sound/misc/burp_alien.ogg', 50, 1)
	//		logTheThing("combat", ownerMob, target, "devours %target% as a ayylien in horror form [log_loc(owner)].")

		//	target.ghostize()
			qdel(target)

	onInterrupt()
		..()
		boutput(owner, "<span style=\"color:red\">Our feasting on [target] has been interrupted!</span>")
*/

/datum/targetable/xenomorph/devour
	name = "Devour"
	desc = "Devour a critter, permanently enhancing your plasma, and temporarily speeding up your healing. Dead humans can also be devoured, and they provide far more benefits than other creatures."
	icon_state = "devour"
	cooldown = 0
	targeted = 0
	target_anything = 0
	restricted_area_check = 2

	cast(atom/target)
		if (..())
			return 1

		var/mob/living/C = holder.owner

		var/obj/item/grab/G

		var/is_pulling = 0

		if (!C.pulling)
			G = src.grab_check(null, 1, 1)
		else
			is_pulling = 1

		if (!G || !istype(G))
			if (!is_pulling)
				return 1

		var/mob/living/T

		if (!is_pulling)
			T = G.affecting
		else
			T = C.pulling

		if (!C:xdevour(T))
			return 1

		if (!istype(T))
			return 1

		if (ismob(T))
			if (ishuman(T))
				if (!ismonkey(T) && T.stat != 2)
					boutput(C, "<span style=\"color:red\"><b>You are unable to devour this creature. It must be dead.</b></span>")
					return 1

		else if (isobj(T))
			if (!iscritter(T))
				boutput(C, "<span style=\"color:red\">This is an object. You cannot devour an object.</span>")
				return 1

		var/T_loc = T.loc
		var/C_loc = C.loc
			/*
		if (istype(T.mutantrace, /datum/mutantrace/monkey))
			boutput(C, "<span style=\"color:red\">Our hunger will not be satisfied by this lesser being.</span>")
			return 1
			*/
			/*
		if (T.bioHolder.HasEffect("husk"))
			boutput(usr, "<span style=\"color:red\">This creature has already been drained...</span>")
			return 1
			*/
		if (T.loc == T_loc && C.loc == C_loc && T && C)
			spawn(rand(7,14))
				if (T && C)
					T.visible_message("<span style=\"color:red\"><b><font size = 3>[T] is devoured by [C]!</span></b></font")
					if (isAlien(C))
						C:mutantrace:maxPlasma += rand(10,50)
						if (ishuman(T))
							C:mutantrace:maxPlasma += rand(40,50)

						C:mutantrace:healrate = ishuman(T) ? 10 : 5
						spawn (rand(80,100) + ishuman(T) ? 500)
							C:mutantrace:healrate = 1
					if (T.client && ismob(T))
						T.ghostize()
					else
						qdel(T)
	//	actions.start(new/datum/action/bar/icon/xenomorphDevour(T, C))
	//	return 0
