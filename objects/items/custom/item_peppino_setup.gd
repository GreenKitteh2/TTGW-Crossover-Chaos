extends ItemCharSetup

func first_time_setup(player : Player) -> void:
	player.stats.gags_unlocked['Throw'] = 1
	player.stats.gags_unlocked['Sound'] = 1
