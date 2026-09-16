extends ItemCharSetup

func first_time_setup(player : Player) -> void:
	player.see_anomalies = true
	player.see_descriptions = true
	for track in Util.get_player().stats.gag_balance.keys():
		Util.get_player().stats.gag_regeneration[track] += 10
