//Cherkir
//Important note: If you are an alien, at least at the time of writing this example, you are of type /mob/living/carbon/human,
//and your mutantrace is set to a datum such as /datum/mutantrace/xenomorph/sentinel, which is what gives you alien properties.
//what happens to your plasma variables in the target datum and cast() procedure below happens to the variables of the mutantrace
//datum, which is reflected in your mob, but does not affect the mob itself in any way whatsoever. This is a principal feature
//of datums. Another example of this is alien icons - your mob icon does not change if you are a human with an alien
//mutantrace, your mutantrace icon is simply loaded instead of it.

/datum/targetable/xenomorph/weed//this is a path. This object inherits from /datum/targetable/xenomorph, giving it certain
//messages when you don't have the requirements to use this skill

	name = "Plant Weeds"//name, seen in the holders stat tab
	desc = "Plant some weeds, which are necessary to expand the hive."//description seen when this is examined in the tab
	icon_state = "weednode"//icon state in alien_ui
	cooldown = 0//any delay for using this?
	targeted = 0//does this need a target?
	target_anything = 0//no, so we don't specify what we can target
	restricted_area_check = 2//and we can't use this in the thunderdome

	cast(atom/target)//cast proc
		if (..())//if there was a delay, and they used it again too quickly, this would return early, preventing the skill
		//from being used
			return 1//return 1 indicates the cause of this return - that they did not get past the delay check

		var/mob/living/C = holder.owner//the holder for this is an /datum/abilityHolder, and its owner is the mob itself.
		//so C is whoever is using this skill, and holder is the datum that holds all sorts of abilities like this one
		//this will actually be of type /mob/living/carbon/human, but we are allowed to reference it as anything that
		//it descends from - /mob, /mob/living, /mob/living/carbon, etc.

		if (!C.loc || !istype(C.loc, /turf/simulated/floor))//is C in the void of nothingness? Is C in space(not on a floor)
			return 0							//notice that !C.loc is equivilant to C.loc == null
												//we check here if C is not of type /turf/simulated/floor.
												//this means it could be /turf/unsimulated/floor, and it would return,
												//but if it was /turf/simulated/floor/somefloor, it would not return.

		if (!istype(C:mutantrace, /datum/mutantrace/xenomorph/drone) && !istype(C:mutantrace, /datum/mutantrace/xenomorph/praetorian))
		//if C is not a drone or a praetorian, they can't make weeds. Queens are descended from drones:
		//drones have the mutantrace path /datum/mutantrace/xenomorph/drone, queens /datum/mutantrace/xenomorph/drone/queen
			boutput(C, "<span style = \"color:red\"><B>Your caste cannot plant weeds.</span></B>")//give them a red, bold
			//message telling them that they can't do anything
			return 0//and return. This 0 indicates that they got past the delay check, whereas 1 indicated that they didn't.

		if (isAlienDrone(C) && C:mutantrace:plasma < 200 || isAlienPraetorian(C) && C:mutantrace:plasma < 100)
		//is C's plasma less than 200, and they're a drone, or if they're a praetorian and it's less than 100
			var/plasma_needed = isAlienDrone(C) ? 200 : 100//are they a drone? They needed 200. Otherwise? 100
			boutput(C, "<span class='game xenobold'>You need at least [plasma_needed] plasma to plant weeds.</span>")
			//give them a message in the span class xenobold(bold, eerie, purple), telling them this. End the class
			//with </span> to prevent errors.
			return 0//return 0


		boutput(C, "<span class='game xenobold'>You plant some weeds.</span>")//give them a message in span class xenobold
		//telling them that they made weeds. Boutput accepts many first parameters: world, clients, and mobs. In this case,
		//we use a mob, but the message goes to the mob's client, the player.

		C:mutantrace:plasma -= isAlienDrone(C) ? 200 : 100//Were they a drone? Decrease their plasma by 200. Otherwise, 100.
		new/obj/xeno/hive/weeds(C.loc, 1)//new weeds at their location. The second parameter says that this is a weed node,
		//so it will expand.
		playsound(C.loc, 'sound/effects/splat.ogg', 100, 1)//splat sound at 100% volume.
		//playsound format should be playsound(turf location, sound path, volume 1 to 100, 1)
		return 0//return 0
