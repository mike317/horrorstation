/obj/xeno/hive/weedover
	layer = TURF_LAYER
	anchored = 1
	density = 0
	name = ""
	var/datum/light/point/light
	luminosity = 0
	layer = EFFECTS_LAYER_UNDER_1
	var/on = 1
	var/brightness = 1.6


/obj/xeno/hive/weeds
	name = "weeds"
	desc = "weird purple weeds"
	icon = 'icons/tg-goon-xenos/xeno.dmi'
	icon_state = "weeds"

	layer = TURF_LAYER
	anchored = 1
	density = 0
	var/obj/xeno/hive/weeds/my_node = null
	var/is_node = 0
	var/expediated = 0//this, from pheromones, will reach ~60 per minute. Therefore, every 100 gives a minor health boost,
	//and(if it's still growing) a range boost

	examine()
		if (isAlien(usr))
			boutput(usr, "Those are just some weeds.")
		else
			boutput(usr, "<span class = \"color:red\"><B>Strange weeds. You feel like you shouldn't go near them...</B></span>")




	New(var/loc = null, var/node = 0)//node being -1 means no spreading



		if (loc)				//and a non-node icon
			src.loc = loc
		else
			del src
			return

		if (node == 1)
			src.icon_state = "weednode"
			is_node = 1
		else
			src.icon_state = pick("weeds", "weeds1", "weeds2")

		if(istype(src.loc, /turf/space))
			qdel(src)
			return

		if (node == 1)
			var/obj/xeno/hive/weedover/w = new/obj/xeno/hive/weedover(src.loc)
			w.light = new
			w.light.set_brightness(w.brightness)
			w.light.set_color(0.66, 0.1, 0.66)
			w.light.set_height(2.4)
			w.light.attach(src)
			w.light.enable()

		if (node != -1)

			SurroundSpreadAll()


	//	global.processing_weeds |= src

	//	Life()//might have to change this

	attackby(obj/item/W as obj, mob/user as mob)
		if (!W) return
		if (!user) return

		if (istype(W, /obj/item/axe)) src.death(40)
		else if (istype(W, /obj/item/circular_saw)) src.death(40)
		else if (istype(W, /obj/item/kitchen/utensil/knife)) src.death(40)
		else if (istype(W, /obj/item/scalpel)) src.death(40)
		else if (istype(W, /obj/item/screwdriver)) src.death(40)
//		else if (istype(W, /obj/item/shard)) src.death()
		else if (istype(W, /obj/item/sword)) src.death(40)
		else if (istype(W, /obj/item/saw)) src.death(40)
		else if (istype(W, /obj/item/weldingtool)) src.death(40)
		else if (istype(W, /obj/item/wirecutters)) src.death(40)



		..()

	proc/SurroundSpreadAll(var/extra_spread = 0)

		spawn(rand(30,60))
			SurroundSpread(1,extra_spread)
		spawn(rand(60,90))
			SurroundSpread(2,extra_spread)
		spawn(rand(90,120))
			SurroundSpread(3,extra_spread)
		spawn(rand(120,150))
			SurroundSpread(4,extra_spread)
		spawn(rand(150,180))
			SurroundSpread(5,extra_spread)
		spawn(rand(180,210))
			SurroundSpread(6,extra_spread)
		spawn(rand(210,240))
			SurroundSpread(7,extra_spread)
		spawn(rand(240,270))
			SurroundSpread(8,extra_spread)

		spawn(rand(270,300))
			SurroundSpread(9,extra_spread)
		spawn(rand(300,330))
			SurroundSpread(9,extra_spread)
		spawn(rand(330,360))
			SurroundSpread(9,extra_spread)
		spawn(rand(360,390))
			SurroundSpread(9,extra_spread)
		spawn(rand(390,420))
			SurroundSpread(9,extra_spread)

		spawn(rand(2700,3000))
			SurroundSpread(10,extra_spread)
		spawn(rand(3000,3300))
			SurroundSpread(10,extra_spread)
		spawn(rand(3300,3600))
			SurroundSpread(10,extra_spread)
		spawn(rand(3600,3900))
			SurroundSpread(10,extra_spread)
		spawn(rand(3900,4200))
			SurroundSpread(10,extra_spread)

	proc/SurroundSpread(var/dir = 0, var/extra_spread)//n = 1, w = 2, e = 3, s = 4, nw = 5, sw = 6, ne = 7
	//se = 8, 9 = random

		if (!src) return
		var/Vspread

		switch (dir)
			if (1)
				Vspread = locate(src.x, src.y+1, src.z)
			if (2)
				Vspread = locate(src.x-1, src.y, src.z)
			if (3)
				Vspread = locate(src.x+1, src.y, src.z)
			if (4)
				Vspread = locate(src.x, src.y - 1, src.z)
			if (5)
				Vspread = locate(src.x-1, src.y+1, src.z)
			if (6)
				Vspread = locate(src.x-1, src.y-1, src.z)
			if (7)
				Vspread = locate(src.x+1, src.y+1, src.z)
			if (8)
				Vspread = locate(src.x+1, src.y-1, src.z)
			if (9)
				Vspread = locate(src.x+rand(-2-extra_spread,2+extra_spread), src.y+rand(-2-extra_spread,2+extra_spread), src.z)
			if (10)
				Vspread = locate(src.x+rand(-3-extra_spread,3+extra_spread), src.y+rand(-3-extra_spread,3+extra_spread), src.z)


		var/dogrowth = 1
		if (!istype(Vspread, /turf/simulated/floor)) dogrowth = 0
		if (Vspread:density) dogrowth = 0

		for(var/obj/O in Vspread)

			if (istype(O, /obj/window) || istype(O, /obj/forcefield) || istype(O, /obj/blob) || istype(O, /obj/spacevine) || istype(O, /obj/xeno/hive/weeds)) dogrowth = 0
			if (istype(O, /obj/machinery/door/))
				if(!O:p_open && prob(70))
					O:open()
					O:operating = -1
				else dogrowth = 0
			else
				if (O.density && O.opacity)
					dogrowth = 0


		if (dogrowth == 1)
			var/obj/xeno/hive/weeds/plantweederryday = new /obj/xeno/hive/weeds(Vspread, -1)
			plantweederryday.my_node = src

			for (var/obj/item/parts/human_parts/p in plantweederryday.loc)
				spawn(rand(600, 900))
					if (plantweederryday && p)
						plantweederryday.visible_message("<span style = \"color:red\">[p] is overcome by the weeds.</span>")
						qdel(p)
			for (var/obj/item/parts/robot_parts/p in plantweederryday.loc)
				spawn(rand(600, 900))
					if (plantweederryday && p)
						plantweederryday.visible_message("<span style = \"color:red\">[p] is overcome by the weeds.</span>")
						qdel(p)
	proc/Spread()
		var/howmuchtofukkenspread = 5

		for (var/i = 1, i <= howmuchtofukkenspread, i++)
			spawn (50)
				if (prob(100))
					SpreadOnce()
			spawn (100)
				if (prob(100))
					SpreadOnce()
			spawn (150)
				if (prob(100))
					SpreadOnce()
			spawn (180)
				if (prob(100))
					SpreadOnce()
					//first 4 weed spreads, guaranteed
			spawn (230)
				if (prob(90))
					SpreadOnce()
			spawn (250)
				if (prob(90))
					SpreadOnce()
			spawn (270)
				if (prob(90))
					SpreadOnce()
			spawn (300)
				if (prob(90))
					SpreadOnce()
					//next 4, almost guaranteed
			spawn (310)
				if (prob(50))
					SpreadOnce()
			spawn (320)
				if (prob(50))
					SpreadOnce()
			spawn (330)
				if (prob(50))
					SpreadOnce()
			spawn (340)
				if (prob(50))
					SpreadOnce()
			spawn (350)
				if (prob(50))
					SpreadOnce()//last 5, eh

	proc/SpreadOnce()//by making each weed spread indiviudally, I think it gives more control over how much we want to make

		if (!src) return
		var/Vspread

		var/redoinc = 0

		redovpsread

		if (prob(50)) Vspread = locate(src.x + rand(-5,5),src.y,src.z)
		else Vspread = locate(src.x,src.y + rand(-5, 5),src.z)

		if (!locate(/obj/xeno/hive/weeds) in range(1, Vspread))
			if (redoinc <= 10)
				goto redovpsread
			redoinc++


		var/dogrowth = 1
		if (!istype(Vspread, /turf/simulated/floor)) dogrowth = 0
		if (Vspread:density) dogrowth = 0

		for(var/obj/O in Vspread)

			if (istype(O, /obj/window) || istype(O, /obj/forcefield) || istype(O, /obj/blob) || istype(O, /obj/spacevine) || istype(O, /obj/xeno/hive/weeds)) dogrowth = 0
			if (istype(O, /obj/machinery/door/))
				if(!O:p_open && prob(70))
					O:open()
					O:operating = -1
				else dogrowth = 0
			else
				if (O.density && O.opacity)
					dogrowth = 0


		if (dogrowth == 1)
			new /obj/xeno/hive/weeds(Vspread, -1)
/*
	proc/Spread(/*datum/controller/process/xenoHive/parent*/)

		var/count = 0
		var/contspread = 1

		while(count < 6)
			if (!contspread) return
			if (!src) return
			contspread = 0
			var/Vspread
			if (prob(50)) Vspread = locate(src.x + rand(-1,1),src.y,src.z)
			else Vspread = locate(src.x,src.y + rand(-1, 1),src.z)
			var/dogrowth = 1
			if (!istype(Vspread, /turf/simulated/floor)) dogrowth = 0
			for(var/obj/O in Vspread)
				if (istype(O, /obj/window) || istype(O, /obj/forcefield) || istype(O, /obj/blob) || istype(O, /obj/spacevine) || istype(O, /obj/xeno/hive/weeds)) dogrowth = 0
				if (istype(O, /obj/machinery/door/))
					if(!O:p_open && prob(70))
						O:open()
						O:operating = -1
					else dogrowth = 0
			if (dogrowth == 1)
				var/obj/xeno/hive/weeds/B = new /obj/xeno/hive/weeds(Vspread)
				spawn(50)
					if(B && prob(5))
						B.Spread()
			count++
		//	sleep(50)//got rid of sleep so that the weed ability doesn't wait on this proc
			spawn (50)
				contspread = 1
				*/

	ex_act(severity)
		switch(severity)
			if(1.0)
				src.death()
				return
			if(2.0)
				if (prob(50))
					src.death()
					return
			if(3.0)
				if (prob(5))
					src.death()
					return
			else
		return

/obj/xeno/hive/weeds/death(var/prob = 100)
	if (prob(prob) || prob == 100)
		visible_message("<span style = \"color:red\"><b>[src] collapses into a pile of resin goop.</span></b>")
		post_death()
		qdel(src)
	else
		visible_message("<span style = \"color:red\"><b>[src] starts to take visible damage.</span></b>")

/obj/xeno/hive/weeds/proc/post_death()
	if (is_node)
		for (var/obj/xeno/hive/weeds/w in range(3, src))
			if (w.my_node == src)
				spawn (rand(50,100))
					qdel(w)

/*
/obj/alien/weeds/burn(fi_amount)
	if (fi_amount > 18000)
		spawn( 0 )
			qdel(src)
			return
		return 0
	return 1
*/

