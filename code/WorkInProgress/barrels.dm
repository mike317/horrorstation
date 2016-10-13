/mob/var/salting_meat = 0

/obj/reagent_barrel
	name = "You should not be able to see this!"
	desc = "You should not be able to see this!"
	icon = 'icons/obj/stationobjs.dmi'
	var/empty_state = "nullbarrel"
	density = 1.0
	anchored = 1.0

	New()
		..()
		reagents = new/datum/reagents(500)

	MouseDrop_T(var/mob/m, var/mob/user)
		if (!ismob(m) || m.stat != 2)
			return

		visible_message("<span style = \"color:blue\">[user] starts covering [m] in salt...</span>")

		spawn (10)

			if (src)
				visible_message("<span style = \"color:blue\">[user] finishes covering [m] in salt.</span>")
				m.salted = 1

	attackby(var/obj/item/o, var/mob/user)


		if (istype(o, /obj/item/reagent_containers/food/snacks/ingredient/meat))
			if (reagents.get_reagent_amount("salt") < 10)
				boutput(user, "There isn't enough salt left to salt this meat with.")
				return
			var/o_loc = o.loc
			var/user_loc = user.loc
			user.visible_message("<span style = \"color:blue\">[user] starts covering [o] in salt.</span>")
			user.salting_meat = 1
			spawn (30)
				if (o_loc == o.loc && user_loc == user.loc && src)
					user.visible_message("<span style = \"color:blue\">[user] finishes covering [o] in salt.</span>")
					reagents.remove_reagent("salt", 10)
					user.salting_meat = 0
					return o:salt()
			user.salting_meat = 0
		else
			if (istype(o, /obj/item/shaker))
				return

	proc/update_icon()
		if (reagents.total_volume < 10)
			icon_state = empty_state
		else
			icon_state = initial(icon_state)

	ex_act(severity)
		switch (severity)
			if (1.0)
				qdel(src)
			if (2.0)
				qdel(src)
			if (3.0)
				qdel(src)

	MouseDrop_T(var/mob/m, var/mob/user)
		if (m == user)
			user.visible_message("<span style = \"color:red\">[user] climbs over [src].</span>", "<span style = \"color:blue\">You climb over [src].</span>")
			spawn (1)
				user.loc = src.loc
		else
			return

	examine()
		boutput(usr, "This is a [src]. It is [round(((reagents.total_volume/500) * 100))]% full.")

/obj/reagent_barrel/salt_barrel
	name = "Salt Barrel"
	icon_state = "saltbarrel"
	desc = "A barrel full of salt."
	New()
		..()
		reagents.add_reagent("salt", 500)

	attackby(var/obj/item/o, var/mob/user)
		if (..(o, user))
			return
		if (istype(o, /obj/item/shaker/salt))
			if (o:shakes == 0)
				boutput(user, "<span style = \"color:red\">[o] is already too full.</span>")
				return
			if (reagents.has_reagent("salt", 10))
				reagents.remove_reagent("salt", 10)
				o:shakes = 0
				user.visible_message("<span style = \"color:red\">[user] fills the [o] with salt.</span>")
			else
				boutput(user, "<span style = \"color:red\>There is not enough salt left in the barrel.</span>")
				update_icon()


/obj/reagent_barrel/rum_barrel
	name = "Rum Barrel"
	icon_state = "rumbarrel"
	desc = "A barrel full of rum."
	New()
		..()
		reagents.add_reagent("rum", 500)

	attackby(var/obj/item/o, var/mob/user)
		if (..(o, user))
			return
		if (istype(o, /obj/item/reagent_containers/food/drinks))
			if (o.reagents.total_volume > 50)
				boutput(user, "<span style = \"color:red\">[o] is already too full.</span>")
				return
			if (reagents.has_reagent("rum", 10))
				reagents.remove_reagent("rum", 10)
				o.reagents.add_reagent("rum", 10)
			else
				boutput(user, "<span style = \"color:red\>There is not enough rum left in the barrel.</span>")
				update_icon()


