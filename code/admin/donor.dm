/client/proc/isDonor()
	var/list/donors = file2text("config/donors.txt")
	for (var/v in donors)
		var/split_v = text2list(v, " - ")
		if (split_v[1] == src.key || split_v[1] == src.ckey)
			return split_v[2]
	return 0