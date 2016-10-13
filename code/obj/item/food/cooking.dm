/obj/item/reagent_containers/food/proc/ferment()
	remove_odd_reagents()
	edible = 1

	reagents.remove_reagent("salmonella", 50)
	reagents.remove_reagent("e.coli", 50)

	if (prob(20))
		reagents.remove_reagent("rancidity", 50)

	cooked = COOKED_FERMENTED
	cooking = 0

/obj/item/reagent_containers/food/proc/cook(var/turf/T = null)
	remove_odd_reagents()
	edible = 1
	reagents.remove_reagent("salmonella", 50)
	reagents.remove_reagent("e.coli", 50)

	if (prob(50))
		reagents.remove_reagent("rancidity", 50)

	cooked = COOKED_COOKED
	cooking = 0

/obj/item/reagent_containers/food/snacks/ingredient/meat/proc/salt()

	if (salted)
		return

	reagents.add_reagent("salt", rand(10,15))
	salted = 1

	if (reagents.get_reagent_amount("salt") >= 10)
		spawn (2000)//creates "aged" meat
			ferment()

	switch (reagents.get_reagent_amount("salt"))
		if (1 to 5)
			name = "[initial(name)]"
		if (6 to 9)
			name = "Moderately-salted [initial(name)]"
		if (10 to INFINITY)
			name = "Salt-[initial(name)]"

/obj/item/reagent_containers/food/snacks/ingredient/meat/cook(var/turf/T)

	..()//change the variables of this base object

	if (T == "FUCK")
		return 0

	//then copy them to the new object, or sometimes the same one

	if (istype(src, /obj/item/reagent_containers/food/snacks/ingredient/meat/bacon))

		name = "cooked bacon"
		var/overlay = icon(icon, "cooked")
		var/icon/i = src.icon
		i.Blend(overlay, ICON_MULTIPLY)
		icon = i
		spoiled -= rand(2,3)
		dysentery -= rand(15,30)//bacon is very safe

		update_spoiled_icon()

	else if (istype(src, /obj/item/reagent_containers/food/snacks/ingredient/meat/monkeymeat))
		var/obj/item/reagent_containers/food/snacks/steak_m/s = new/obj/item/reagent_containers/food/snacks/steak_m(T)

		src.reagents.copy_to(s.reagents)

		s.spoiled = src.spoiled
		s.dysentery = src.dysentery

		s.name = "cooked meat"
		s.spoiled -= rand(1,3)
		s.dysentery -= rand(10,20)

		s.update_spoiled_icon()

	else if (istype(src, /obj/item/reagent_containers/food/snacks/ingredient/meat/humanmeat))
		var/obj/item/reagent_containers/food/snacks/steak_h/s = new/obj/item/reagent_containers/food/snacks/steak_h(T)
		//actually fuck it how would you be able to tell that this is human meat
		src.reagents.copy_to(s.reagents)

		s.spoiled = src.spoiled
		s.dysentery = src.dysentery

		var/modifier = pick("chewy", "disgusting", "odd-looking", "weird")

		s.name = "[modifier] cooked meat"
		s.spoiled -= rand(1,2)
		s.dysentery -= rand(5,10)//human meat is less safe than other meats
	//	if (v:name == "steak")//retarded fix for a retarded bug where monkey meat was being named human meat
		//	v:name = "Human Meat"
	else
		var/obj/item/reagent_containers/food/snacks/steak_generic/s = new/obj/item/reagent_containers/food/snacks/steak_generic(T)
		src.reagents.copy_to(s.reagents)

		s.spoiled = src.spoiled
		s.dysentery = src.dysentery

		s.name = "cooked meat"
		s.spoiled -= rand(1,3)
		s.dysentery -= rand(10,20)


	if (src)
		qdel(src)
	else
		return

/obj/item/reagent_containers/food/snacks/plant/cook(var/turf/T)

	..()//cook it

	if (T == "FUCK")
		return 0

	var/obj/item/reagent_containers/food/snacks/plant/p = new/obj/item/reagent_containers/food/snacks/plant(T)


	p.spoiled = src.spoiled
	p.dysentery = src.dysentery

	p.icon = src.icon
	p.icon_state = src.icon_state


	var/overlay = icon(p.icon, "cooked")
	var/icon/i = src.icon
	i.Blend(overlay, ICON_MULTIPLY)
	p.icon = i

	src.reagents.copy_to(p.reagents)
	p.name = "cooked [src]"
	p.edible = 1
	p.spoiled -= rand(2,5)//plants are easier to unspoil by cooking
	p.dysentery -= rand(20,30)

	if (src)
		qdel(src)
	else
		return


/obj/burning_barrel
	name = "burning barrel"
	desc = "Useful for cooking some things."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "barrel1"
	density = 1
	anchored = 1
	opacity = 0

	var/datum/particleSystem/barrelSmoke/particles
	var/datum/light/light

	New()
		particles = particleMaster.SpawnSystem(new /datum/particleSystem/barrelSmoke(src))
		light = new /datum/light/point
		light.attach(src)
		light.set_brightness(1)
		light.set_color(0.5, 0.3, 0)
		light.enable()

		..()

	Del()
		particleMaster.RemoveSystem(/datum/particleSystem/barrelSmoke, src)
		..()

	MouseDrop_T(mob/m as mob, mob/living/carbon/user as mob)
		var/m_loc = m.loc
		var/user_loc = user.loc

		if (m != user)

			user.visible_message("<span style = \"color:red\">[user] starts to put [m] on the barrel.</span>", "<span style = \"color:red\">You start to put [m] on the barrel.</span>")
			spawn(5)
				if (m.loc == m_loc && user.loc == user_loc)
					if (src)
						m.set_loc(src.loc)
						if (m.stat != 2)
							m.emote("scream")
						m.TakeDamage("ALL", 0, 20, 0)
						return
		else

			if (prob(80) || isTrueAlien(user))
				user.visible_message("<span style = \"color:red\">[user] climbs over the barrel.</span>", "<span style = \"color:red\">You climb over the barrel.</span>")
				spawn(2)
					if (!src || user_loc != user.loc)
						return
					user.set_loc(src.loc)

			else
				if (!src || user_loc != user.loc)
					return
				user.set_loc(src.loc)
				user.visible_message("<span style = \"color:red\">You try to climb over the barrel, but burn yourself!</span>", "<span style = \"color:red\">[user] tries to climb over the barrel, but burns [his_or_her(user)]self!</span>")
				if (ishuman(user) && !isAlien(user))
					user.TakeDamage("ALL", 0, 10, 0)
				else if (isAlienHugger(user) || isAlienLarva(user))
					user.death()//kek
				user.weakened += 5
				user.stunned += 5

	suicide(mob/living/carbon/user as mob)

		visible_message("<b>[user]</b> jumps into the [src]! It looks like they're trying to commit suicide.</span>")
		user.emote("scream")
		var/mob/m = user
		user.ghostize()
		qdel(m)


	attackby(obj/item/reagent_containers/food/edible as obj, mob/living/carbon/user as mob)//HEATING DRINKS

		if (!istype(edible))
			return

/*
		if (edible.cooked == COOKED_FERMENTED)
			boutput(user, "<span style = \"color:blue\">[edible] appears to be fermented. Cooking it would be excessive.</span>")
			return
			*/

		if (istype(edible, /obj/item/reagent_containers/food/drinks) && edible.edible && edible.cooked == COOKED_COOKED)//this is to prevent people
		//from cooking things over and over to practically guarantee getting rid of rancidity/e.coli/salmonella
			user.visible_message("<span style = \"color:red\"><b>[user]</b> holds [edible] over [src]'s flame, but it is already hot and dissolves!</span>")
			edible.reagents = new/datum/reagents()
			return


		if (istype(edible, /obj/item/reagent_containers/food) && !istype(edible, /obj/item/reagent_containers/food/drinks) && edible.edible && edible.cooked == COOKED_COOKED)//this is to prevent people
		//from cooking things over and over to practically guarantee getting rid of rancidity/e.coli/salmonella
			user.visible_message("<span style = \"color:red\"><b>[user] holds [edible] over [src]'s flame, but it is already cooked and burns up!</span>")
			new/obj/item/reagent_containers/food/snacks/yuckburn(loc)
			qdel(edible)
			return

		if (istype(edible, /obj/item/reagent_containers/food/drinks))//HEATING WATER
			if (edible.reagents && edible.reagents.total_volume > 0)
				var/obj/item/reagent_containers/food/drinks/drink = edible
				if (drink.heating)
					return

				var/heat_time = drink.heat_time
				drink.heating = 1
				user.visible_message("<span style = \"color:blue\">[user] holds [drink] over [src]'s flame, starting to heat its contents.</span>", "<span style = \"color:blue\">You hold the [edible] over [src]'s flame, starting to heat its contents.</span>")

				var/random_decimal = rand(75,125)
				random_decimal/=100
				spawn (heat_time * random_decimal)
					if (src && locate(user) in range(1, src))
						drink.heating = 0
						user.visible_message("<span style = \"color:blue\">[user] finishes heating [drink].</span>", "<span style = \"color:blue\">You finish heating [drink].</span>")
						drink.cook()


		else if (istype(edible, /obj/item/reagent_containers/food/snacks/plant))//COOKING VEGGIES
			var/obj/item/reagent_containers/food/snacks/plant = edible

			if (!istype(plant) || !plant)
				return

			if (istype(plant, /obj/item/reagent_containers/food) && plant.edible && plant.cooked == COOKED_COOKED)//this is to prevent people
			//from cooking things over and over to practically guarantee getting rid of rancidity/e.coli/salmonella
				user.visible_message("<span style = \"color:red\"><b>[user] holds [plant] over [src]'s flame, but it is already cooked and burns up!</span>")
				new/obj/item/reagent_containers/food/snacks/yuckburn(loc)
				qdel(plant)
				return

			if (plant.cooking)
				return

			var/cook_time = plant.cook_time
			plant.cooking = 1


			user.visible_message("<span style = \"color:blue\">[user] holds [plant] over [src]'s flame, starting to roast it.", "<span style = \"color:red\">You hold [plant] over [src]'s flame, starting to roast it.</span>")

			sleep (rand(cook_time,cook_time*2))
			if (plant && plant.loc == user && locate(src) in range(1, user))
				visible_message("<span style = \"color:blue\">[plant] starts to brown.</span>")
			else
				if (plant)
					plant.cooking = 0
				return

			sleep (rand(cook_time,cook_time*1.5))
			if (plant && plant.loc == user && locate(src) in range(1, user))
				visible_message("<span style = \"color:blue\">[plant] smells pretty good. It must be cooking nicely.</span>")
			else
				if (plant)
					plant.cooking = 0
				return

			sleep (rand(cook_time,cook_time*1.3))
			if (plant && plant.loc == user && locate(src) in range(1, user))
				visible_message("<span style = \"color:blue\">[plant] starts to get crispier.</span>")
			else
				if (plant)
					plant.cooking = 0
				return

			sleep (rand(cook_time,cook_time*1.1))
			if (plant && plant.loc == user && locate(src) in range(1, user))
				visible_message("<span style = \"color:blue\">[plant] appears to be done cooking.</span>")
			else
				if (plant)
					plant.cooking = 0
				return

			if (plant)
				plant.cook(src ? src.loc : user ? user:loc : "FUCK")
			else
				return


		else if (istype(edible, /obj/item/reagent_containers/food/snacks/ingredient/meat) && edible.edible)//COOKING MEAT
			var/obj/item/reagent_containers/food/snacks/ingredient/meat/food = edible

			if (!istype(food) || !food)
				return

			if (food.cooking)
				return

			if (istype(food, /obj/item/reagent_containers/food) && food.edible && food.cooked == COOKED_COOKED)//this is to prevent people
			//from cooking things over and over to practically guarantee getting rid of rancidity/e.coli/salmonella
				user.visible_message("<span style = \"color:red\"><b>[user] holds [food] over [src]'s flame, but it is already cooked and burns up!</span>")
				new/obj/item/reagent_containers/food/snacks/yuckburn(loc)
				qdel(food)
				return

			var/cook_time = food.cook_time
			food.cooking = 1

			user.visible_message("<span style = \"color:blue\">[user] holds [food] over [src]'s flame, starting to cook it.", "<span style = \"color:red\">You hold [food] over [src]'s flame, starting to cook it.</span>")

			sleep (rand(cook_time,cook_time*2))
			if (food && food.loc == user && locate(src) in range(1, user))
				visible_message("<span style = \"color:blue\">[food] starts to turn from red to brown.</span>")
			else
				if (food)
					food.cooking = 0
				return

			sleep (rand(cook_time,cook_time*1.5))
			if (food && food.loc == user && locate(src) in range(1, user))
				visible_message("<span style = \"color:blue\">[food] smells pretty good. It must be cooking nicely.</span>")
			else
				if (food)
					food.cooking = 0
				return

			sleep (rand(cook_time,cook_time*1.3))
			if (food && food.loc == user && locate(src) in range(1, user))
				visible_message("<span style = \"color:blue\">[food] starts to get crispier.</span>")
			else
				if (food)
					food.cooking = 0
				return

			sleep (rand(cook_time,cook_time*1.1))
			if (food && food.loc == user && locate(src) in range(1, user))
				visible_message("<span style = \"color:blue\">[food] appears to be done cooking.</span>")
			else
				if (food)
					food.cooking = 0
				return

			if (food)
				food.cook(src ? src.loc : user ? user:loc : "FUCK")
			else
				return