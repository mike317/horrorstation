/mob/verb/who()
	set name = "Who"
	var/rendered = "---------------------<br>"

	var/list/whoAdmins = list()
	var/list/whoMentors = list()
	var/list/whoNormies = list()

	var/list/whoGimmicks = list()
	var/list/whoCodermins = list()
	var/list/whoCoders = list()
	var/list/whoIconners = list()
	var/list/whoMappers = list()

	for (var/mob/M in mobs)
		if (!M.client) continue

		//Admins
		if (M.client.holder)
			var/thisW = "<span class='adminooc text-normal'>"

			var/clist = whoAdmins

			switch (M.client.holder.rank)
				if ("Coder")
					thisW = "<span class='coderooc text-normal'>"
					clist = whoCoders
				if ("Iconner")
					thisW = "<span class='coderooc text-normal'>"
					clist = whoIconners
				if ("Mapper")
					thisW = "<span class='coderooc text-normal'>"
					clist = whoMappers
				if ("Codermin")
					thisW = "<span class='coderminooc text-normal'>"
					clist = whoCodermins

			if (thisW == initial(thisW))
				if (M.client.holder.level == LEVEL_NOPOWER)
					thisW = "<span class='coderooc text-normal'>"
					clist = whoCoders



			if (usr.client.holder) //The viewer is an admin, we can show them stuff
				if (M.client.stealth || M.client.alt_key)
					thisW += "[M.client.key] <i>(as [M.client.fakekey])</i></span>"
					clist += thisW
				else
					thisW += "[M.client.key]</span>"
					clist += thisW

			else //A lowly normal person is viewing, hide!
				if (M.client.alt_key)
					thisW += "[M.client.fakekey]</span>"
					clist += thisW
				else if (M.client.stealth) // no you fucks don't show us as an admin anyway!!
					clist += "<span class='ooc text-normal'>[M.client.fakekey]</span>"
				else
					thisW += "[M.client.key]</span>"
					clist += thisW

		//Mentors
		else if (M.client.mentor)
			whoMentors += "<span class='mentorooc text-normal'>[M.client.key]</span>"

		//Normies
		else
			if (M.client.isDonor())
				whoGimmicks += "<span class='donor1ooc text-normal'>[M.client.key] - [M.client.isDonor()]</span>"
			else
				whoNormies += "<span class='ooc text-normal'>[M.client.key]</span>"

	whoAdmins = sortList(whoAdmins)
	whoMentors = sortList(whoMentors)
	whoNormies = sortList(whoNormies)
	whoGimmicks = sortList(whoGimmicks)
	whoCoders = sortList(whoCoders)
	whoCodermins = sortList(whoCodermins)

	if (whoAdmins.len)
		rendered += "<b>Admins:</b><br>"
		for (var/anAdmin in whoAdmins)
			rendered += anAdmin + "<br>"
	if (whoMentors.len)
		rendered += "<b>Mentors:</b><br>"
		for (var/aMentor in whoMentors)
			rendered += aMentor + "<br>"
	if (whoNormies.len)
		rendered += "<b>Normal:</b><br>"
		for (var/aNormie in whoNormies)
			rendered += aNormie + "<br>"
	if (whoGimmicks.len)
		rendered += "<b>Donors:</b><br>"
		for (var/aDonor in whoGimmicks)
			rendered += aDonor + "<br>"
	if (whoCoders.len)
		rendered += "<b>Coders:</b><br>"
		for (var/aCoder in whoCoders)
			rendered += aCoder + "<br>"
	if (whoCodermins.len)
		rendered += "<b>Coder Admins:</b><br>"
		for (var/aCoderMin in whoCodermins)
			rendered += aCoderMin + "<br>"


	rendered += "<b>Total Players: [whoAdmins.len + whoMentors.len + whoNormies.len + whoGimmicks.len + whoCoders.len + whoIconners.len + whoMappers.len + whoCodermins.len]</b><br>"
	rendered += "---------------------"
	boutput(usr, rendered)

/client/verb/adminwho()
	set category = "Commands"

	var/adwnum = 0
	var/rendered = ""
	rendered += "<b>Remember: even if there are no admins ingame, your adminhelps will still be sent to our IRC channel. Current Admins:</b><br>"

	for (var/mob/M in mobs)
		if (M && M.client && M.client.holder && !M.client.player_mode)
			if (usr.client.holder)
				if (M.client.holder.rank == "Administrator")
					rendered += "[M.key] is an [M.client.holder.rank][(M.client.stealth || M.client.fakekey) ? " <i>(as [M.client.fakekey])</i>" : ""]<br>"
				else
					rendered += "[M.key] is a [M.client.holder.rank][(M.client.stealth || M.client.fakekey) ? " <i>(as [M.client.fakekey])</i>" : ""]<br>"
			else
				if (M.client.alt_key)
					rendered += "&emsp;[M.client.fakekey]<br>"
					adwnum++
				else if (!M.client.stealth)
					rendered += "&emsp;[M.client]<br>"
					adwnum++

	rendered += "<br><b>Current Mentors:</b><br>"

	for (var/mob/M in mobs)
		if(M && M.client && M.client.mentor)
			rendered += "&emsp;[M.client]<br>"

	boutput(usr, rendered)

	if(!usr.client.holder)
		logTheThing("admin", usr, null, "used adminwho and saw [adwnum] admins.")
		logTheThing("diary", usr, null, "used adminwho and saw [adwnum] admins.", "admin")
		if(adwnum < 1)
			message_admins("<span style=\"color:blue\">[key_name(usr)] used adminwho and saw [adwnum] admins.</span>")