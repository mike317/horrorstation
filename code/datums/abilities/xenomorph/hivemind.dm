/mob/living/carbon/human/proc/xeno_hive_talk(var/message)

	if (!isAlien(src))
		return

	logTheThing("diary", src, null, ": [message]", "say")

	message = trim(html_encode(message))

	if (!message)
		return

	var/message_a = src.say_quote(message)
	var/queentext = ""
	var/queentextend = ""

	if (isAlienWarrior(src) || isAlienPraetorian(src) || isAlienQueen(src))
		queentext = "<font size = 3>"
		queentextend = "</font>"

	var/rendered = "[queentext]<i><span class='game say'>Hivemind, <span class='name' data-ctx='\ref[src.mind]'>[src.name]</span> <span class='message'>[message_a]</span></span></i>[queentextend]"
	for (var/mob/living/carbon/human/H in mobs)
		if(!H.stat)
			if(isAlien(H))
				var/thisR = rendered
			//	if (H.client && H.client.holder && src.mind)
			//		thisR = "<span class='adminHearing' data-ctx='[S.client.chatOutput.ctxFlag]'>[rendered]</span>"
				H.show_message(thisR, 2)


	var/list/listening = hearers(1, src)
	listening -= src
	listening += src

	var/list/heard = list()
	for (var/mob/M in listening)
		if(!isAlien(M))
			heard += M


	if (length(heard))
		var/message_b

		message_b = pick("hisses quietly", "hisses loudly", "hisses softly")
			//for emurshun make this depend on what they actually saym
			//loudly for anything with exclamations, softly for questions?
		message_b = src.say_quote(message_b)
		message_b = "<i>[message_b]</i>"

		rendered = "<i><span class='game say'><span class='name' data-ctx='\ref[src.mind]'>[src.voice_name]</span> <span class='message'>[message_b]</span></span></i>"

		for (var/mob/M in heard)
			var/thisR = rendered
		//	if (M.client && M.client.holder && src.mind)
			//	thisR = "<span class='adminHearing' data-ctx='[M.client.chatOutput.ctxFlag]'>[rendered]</span>"
			M.show_message(thisR, 2)

	message = src.say_quote(message)

	rendered = "<i><span class='game say'>Hivemind, <span class='name' data-ctx='\ref[src.mind]'>[src.name]</span> <span class='message'>[message_a]</span></span></i>"

	for (var/mob/M in mobs)
		if (istype(M, /mob/new_player))
			continue
		if (M.stat > 1 && !istype(M, /mob/dead/target_observer))
			var/thisR = rendered
		//	if (M.client && M.client.holder && src.mind)
			//	thisR = "<span class='adminHearing' data-ctx='[M.client.chatOutput.ctxFlag]'>[rendered]</span>"
			M.show_message(thisR, 2)
		//	*/