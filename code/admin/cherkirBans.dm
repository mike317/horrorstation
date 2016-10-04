
#define BYPASSTEST 0//test to let me ban myself
//simpler, probably temporary ban system
client/proc/sadd_to_address_ban_file(var/hours, var/note)

	if (!hours)
		hours = 1
	if (!note)
		note = "no note"

	var/savefile/s = new("Cherkirbans/address/[address ? address : "null"].sav")
	if (hours != -1)
		s["bannedtime"] << hours
	else
		s["bannedtime"] << -1

	s["timewhenbanned"] << world.realtime
	s["note"] << note

	return 1

client/proc/sadd_to_ckey_ban_file(var/hours, var/note)

	if (!hours)
		hours = 1
	if (!note)
		note = "no note"

	var/savefile/s = new("Cherkirbans/ckey/[ckey].sav")
	if (hours != -1)
		s["bannedtime"] << hours//bannedtime is done by minutes: One minute is 600 1/10th seconds
	else
		s["bannedtime"] << -1

	s["timewhenbanned"] << world.realtime
	s["note"] << note

	return 1

client/proc/sadd_to_compid_ban_file(var/hours, var/note)

	if (!hours)
		hours = 1
	if (!note)
		note = "no note"

	var/savefile/s = new("Cherkirbans/compid/[computer_id].sav")
	if (hours != -1)
		s["bannedtime"] << hours//bannedtime is done by minutes: One minute is 600 1/10th seconds
	else
		s["bannedtime"] << -1

	s["timewhenbanned"] << world.realtime
	s["note"] << note

	return 1

client/proc/scheck_if_banned()

	message_admins("<span style = \"color:blue\">Checking ban file for [src].</span>")

	var/savefile/addresscheck1 = "Cherkirbans/address/[address].sav"
	var/savefile/ckeycheck1 = "Cherkirbans/ckey/[ckey].sav"
	var/savefile/compidcheck1 = "Cherkirbans/compid/[computer_id].sav"

	if (!fexists(addresscheck1) && !fexists(ckeycheck1) && !fexists(compidcheck1))
		message_admins("<span style = \"color:blue\">[src] tried to log in, passed ban check. No banned files.</span>")
		return 0

	var/savefile/addresscheck = new("Cherkirbans/address/[address].sav")
	var/savefile/ckeycheck = new("Cherkirbans/ckey/[ckey].sav")
	var/savefile/compidcheck = new("Cherkirbans/compid/[computer_id].sav")

	var/banned_time = 0
	var/time_when_banned = 0
	var/reason_banned = null

	if (!fexists(addresscheck1) && !fexists(ckeycheck1) && !fexists(compidcheck1))
		message_admins("<span style = \"color:blue\">[src] tried to log in, passed ban check. No banned files.</span>")
		return 0

	if (fexists(addresscheck1))
		addresscheck["bannedtime"] >> banned_time
		addresscheck["timewhenbanned"] >> time_when_banned
		addresscheck["note"] >> reason_banned

	banned_time = text2num(banned_time)
	time_when_banned = text2num(time_when_banned)

	if (banned_time == -1)
		message_admins("<span style = \"color:blue\">[src] tried to log in, failed ban check. Permabanned.</span>")
		return "permabanned"

	if (fexists(ckeycheck1))
		var/v

		ckeycheck["bannedtime"] >> v
		if (text2num(v) > banned_time)
			banned_time = v

		ckeycheck["timewhenbanned"] >> v
		if (text2num(v) > time_when_banned)
			time_when_banned = v

		var/noteaddition = ""

		ckeycheck["note"] >> noteaddition

		if (noteaddition)
			reason_banned += ";[noteaddition]"

	banned_time = text2num(banned_time)
	time_when_banned = text2num(time_when_banned)

	if (banned_time == -1)
		message_admins("<span style = \"color:blue\">[src] tried to log in, failed ban check. Permabanned.</span>")
		return "permabanned"

	if (fexists(compidcheck1))

		var/v

		compidcheck["bannedtime"] >> v

		if (text2num(v) > banned_time)
			banned_time = v

		compidcheck["timewhenbanned"] >> v

		if (text2num(v) > time_when_banned)
			time_when_banned = v

		var/noteaddition = ""

		compidcheck["note"] >> noteaddition

		if (noteaddition)
			reason_banned += ";[noteaddition]"

	banned_time = text2num(banned_time)
	time_when_banned = text2num(time_when_banned)

	if (banned_time == 0 || time_when_banned == 0)
		message_admins("<span style = \"color:blue\">[src] tried to log in, passed ban check.</span>")
		sunban(address, ckey, computer_id, null, null)
		return 0

	if (banned_time == -1)
		message_admins("<span style = \"color:blue\">[src] tried to log in, failed ban check. Permabanned.</span>")
		return "permabanned"

		//realtime and time_when_banned are already in deciseconds
	var/time_since_ban = world.realtime - time_when_banned//if they're banned at, eg: 10 billion
	//realtime, and it's now 11 billion realtime, 1 billion deciseconds have elapsed
	var/time_need_elapsed = banned_time * 36000//1 hour = 36000 deciseconds

//	if (time_when_banned + (banned_time * 36000) >= world.realtime)
	if (time_since_ban >= time_need_elapsed)
		message_admins("<span style = \"color:blue\">[src] tried to log in, passed ban check. Was previously banned.</span>")
		sunban()			//hours to deciseconds
		return 0//not banned
	else
		message_admins("<span style = \"color:blue\">[src] tried to log in, failed ban check.</span>")
		return "banned for another [((time_need_elapsed - time_since_ban)/36000)] hours."

client/proc/saddban(var/hours, var/reason, var/client/banner)
	if (holder && !BYPASSTEST)
		if (banner)
			alert(banner, "You can't ban another admin.")
		return 0

	if (sadd_to_address_ban_file(hours, reason))
		if (sadd_to_ckey_ban_file(hours, reason))
			if (sadd_to_compid_ban_file(hours, reason))
				message_admins("<span style=\"color:blue\">[key_name(banner)] has banned [key_name(src)] for [reason].</span>")
				logTheThing("admin", banner, src, "has banned [key_name(src)] for: [reason]")
				logTheThing("diary", banner, src, "has banned [key_name(src)] for: [reason]", "admin")

				boutput(src, "<span style = \"color:red\">You've been banned for [hours] hours. Reason: [reason]</span>")
				del(src)


proc/sunban(var/uaddress, var/uckey, var/ucompid, var/reason, var/client/unbanner)

	var/savefile/addresscheck = new("Cherkirbans/address/[uaddress].sav")
	var/savefile/ckeycheck = new("Cherkirbans/ckey/[uckey].sav")
	var/savefile/compidcheck = new("Cherkirbans/compid/[ucompid].sav")

	if (addresscheck)
		fdel(addresscheck)
	if (ckeycheck)
		fdel(ckeycheck)
	if (compidcheck)
		fdel(compidcheck)

	if (unbanner)
		message_admins("<span style=\"color:blue\">[key_name(unbanner)] has unbanned [uaddress]/[uckey]/[ucompid] for [reason].</span>")
		logTheThing("admin", unbanner, src, "has unbanned [uaddress]/[uckey]/[ucompid] for: [reason]")
		logTheThing("diary", unbanner, src, "has unbanned [uaddress]/[uckey]/[ucompid] for: [reason]", "admin")
	else
		if (!reason)
			message_admins("<span style=\"color:blue\">[uaddress]/[uckey]/[ucompid]'s ban has expired.</span>")