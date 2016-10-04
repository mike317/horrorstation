
/obj/item/raw_material/proc/refine(var/obj/item/weapon, var/mob/living/carbon/human/user)//weapon == null when they use hands
	var/melt_time = 0
	var/action_name = "do something that should not be possible to see, please contact a coder"
	var/action_addendum = ""

	switch (ghetto_refine_stage)

		if (STAGE_START)
			action_name = "start preparing the [src] for manipulation"
		if (STAGE_HARD_CUT)
			action_name = "chop"
		if (STAGE_SMELT)
			action_name = "lightly smelt"
		if (STAGE_SMELT_MORE)
			action_name = "smelt"
		if (STAGE_MELT)
			action_name = "melt"
		if (STAGE_BURN)
			action_name = "burn"
		if (STAGE_SOFT_CUT)
			action_name = pick("slice", "cut")
		if (STAGE_SHAPE)
			if (weapon)
				action_name = "pound"
				action_addendum = "with the [weapon]"
			else
				action_name = "shape"
				action_addendum = "with your hands"
		if (STAGE_REFINE)
			if (weapon)
				action_name = "brutally pound"
				action_addendum = "with the [weapon]"
			else
				action_name = "gently refine"
				action_addendum = "with your hands"

	if (weapon)
		if (weapon.hit_type == DAMAGE_BLUNT)
			if (ghetto_refine_stage in list(STAGE_START, STAGE_HARD_CUT, STAGE_SMELT, STAGE_SMELT_MORE, STAGE_MELT, STAGE_BURN, STAGE_SOFT_CUT))
				boutput(user, "<span style = \"color:red\">You can't think of what to do to this with [weapon].</span>")
		else if (weapon.hit_type == DAMAGE_STAB)
			if (ghetto_refine_stage in list(STAGE_START, STAGE_HARD_CUT, STAGE_SMELT, STAGE_SMELT_MORE, STAGE_MELT, STAGE_BURN, STAGE_SOFT_CUT))
				melt_time = rand(manipulation_time, manipulation_time + 100)
		else if (weapon.hit_type == DAMAGE_CUT)
			if (ghetto_refine_stage in list(STAGE_START, STAGE_HARD_CUT, STAGE_SMELT, STAGE_SMELT_MORE, STAGE_MELT, STAGE_BURN, STAGE_SOFT_CUT))
				melt_time = rand(manipulation_time, manipulation_time + 10)


	if (melt_time)
		sleep(melt_time)
	else
		if (ghetto_refine_stage in list(STAGE_START, STAGE_SHAPE, STAGE_REFINE))
			if (weapon)
				if (weapon.hit_type == DAMAGE_BLUNT)
					boutput(user, "<span style = \"color:red\">You start to [action_name] the [src] [action_addendum].</span>")
				else
					boutput(user, "<span style = \"color:red\">You can't [action_name] the [src] with [weapon].</span>")
			else//add a burn check here if they aren't wearing good gloves
				boutput(user, "<span style = \"color:red\">You start to [action_name] the [src] [action_addendum].</span>")
			sleep(melt_time/2)

	boutput(user, "<span style = \"color:red\">You finish [action_name]ing the [src] [action_addendum].</span>")

	switch (ghetto_refine_stage)

		if (STAGE_START)
			ghetto_refine_stage = STAGE_HARD_CUT
			if (end_at_stage == ghetto_refine_stage)
				ghetto_refine_stage = STAGE_FINAL
		if (STAGE_HARD_CUT)
			ghetto_refine_stage = STAGE_SMELT
			if (end_at_stage == ghetto_refine_stage)
				ghetto_refine_stage = STAGE_FINAL
		if (STAGE_SMELT)
			ghetto_refine_stage = STAGE_SMELT_MORE
			if (end_at_stage == ghetto_refine_stage)
				ghetto_refine_stage = STAGE_FINAL
		if (STAGE_SMELT_MORE)
			ghetto_refine_stage = STAGE_MELT
			if (end_at_stage == ghetto_refine_stage)
				ghetto_refine_stage = STAGE_FINAL
		if (STAGE_MELT)
			ghetto_refine_stage = STAGE_BURN
			if (end_at_stage == ghetto_refine_stage)
				ghetto_refine_stage = STAGE_FINAL
		if (STAGE_BURN)
			ghetto_refine_stage = STAGE_SOFT_CUT
			if (end_at_stage == ghetto_refine_stage)
				ghetto_refine_stage = STAGE_FINAL
		if (STAGE_SOFT_CUT)
			ghetto_refine_stage = STAGE_SHAPE
			if (end_at_stage == ghetto_refine_stage)
				ghetto_refine_stage = STAGE_FINAL
		if (STAGE_SHAPE)
			ghetto_refine_stage = STAGE_REFINE
			if (end_at_stage == ghetto_refine_stage)
				ghetto_refine_stage = STAGE_FINAL
		if (STAGE_REFINE)
			ghetto_refine_stage = STAGE_FINAL
			if (end_at_stage == ghetto_refine_stage)
				ghetto_refine_stage = STAGE_FINAL