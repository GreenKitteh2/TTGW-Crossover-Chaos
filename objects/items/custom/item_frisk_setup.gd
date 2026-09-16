extends ItemCharSetup

func first_time_setup(player : Player) -> void:
	player.stats.gags_unlocked['Squirt'] = 1
	player.stats.gags_unlocked['Lure'] = 1
	player.see_anomalies = true
	player.see_descriptions = true
