/mob/proc/xmelee_attack_normal(var/mob/living/carbon/human/target, var/extra_damage = 0, var/suppress_flags = 0, var/damtype = DAMAGE_CRUSH)
	if(!src || !target)
		return 0

	if(!isnum(extra_damage))
		extra_damage = 0

	if (!target.melee_attack_test(src))
		return

	var/obj/item/affecting = target.get_affecting(src)
	var/datum/attackResults/msgs = xcalculate_melee_attack(target, affecting, 2, 9, extra_damage)
	msgs.damage_type = damtype
	attack_effects(target, affecting)
	msgs.flush(suppress_flags)

/mob/proc/xcalculate_melee_attack(var/mob/target, var/obj/item/affecting, var/base_damage_low = 2, var/base_damage_high = 9, var/extra_damage = 0)
	var/datum/attackResults/msgs = new(src)
	msgs.clear(target)
	msgs.valid = 1

	var/def_zone = null
	if (istype(affecting, /obj/item/organ))
		var/obj/item/organ/O = affecting
		def_zone = O.organ_name
		msgs.affecting = affecting
	else if (istype(affecting, /obj/item/parts))
		var/obj/item/parts/P = affecting
		def_zone = P.slot
		msgs.affecting = affecting
	else if (zone_sel)
		def_zone = zone_sel.selecting
		msgs.affecting = def_zone
	else
		def_zone = "All"
		msgs.affecting = def_zone

	var/punchmult = get_base_damage_multiplier(def_zone)
	var/punchedmult = target.get_taken_base_damage_multiplier(src, def_zone)

	if (!punchedmult)
		if (narrator_mode)
			msgs.played_sound = 'sound/vox/hit.ogg'
		else
			msgs.played_sound = 'sound/weapons/slashcut.ogg'
		msgs.visible_message_self("<span style=\"color:red\"><B>[src] slashes [target], but it does absolutely nothing!</B></span>")
		return

	if (!punchmult)
		msgs.played_sound = 'sound/weapons/slashcut.ogg'
		msgs.visible_message_self("<span style=\"color:red\"><B>[src] slashes [target] with a ridiculously feeble attack!</B></span>")
		return

	var/damage = rand(base_damage_low, base_damage_high) * punchedmult * punchmult + extra_damage + calculate_bonus_damage(msgs)

	if (!target.canmove && target.lying)
		msgs.played_sound = 'sound/weapons/slashcut.ogg'
		msgs.base_attack_message = "<span style=\"color:red\"><B>[src] slashes [target]!</B></span>"
		msgs.logs = list("[src.kickMessage] %target%")

		if(STAMINA_LOW_COST_KICK)
			msgs.stamina_self += STAMINA_HTH_COST / 3
	else
		msgs.base_attack_message = "<span style=\"color:red\"><B>[src] slashes [target]!</B></span>"
		msgs.played_sound = "sound/weapons/slashcut.ogg"

		def_zone = target.check_target_zone(def_zone)

		var/armor_mod = 0
		if (def_zone == "head")
			armor_mod = target.get_head_armor_modifier()
		else if (def_zone == "chest")
			armor_mod = target.get_chest_armor_modifier()
		damage -= armor_mod
		msgs.stamina_target -= max(STAMINA_HTH_DMG - armor_mod, 0)

		if (prob(STAMINA_CRIT_CHANCE * 2))
			msgs.stamina_crit = 1
			msgs.played_sound = "sound/weapons/slashcut.ogg"
			msgs.visible_message_target("<span style=\"color:red\"><B><I>... and lands a devastating hit!</B></I></span>")

	var/attack_resistance = target.check_attack_resistance()
	if (attack_resistance)
		damage = 0
		if (istext(attack_resistance))
			msgs.show_message_target(attack_resistance)
	msgs.damage = max(damage, 0)

	return msgs