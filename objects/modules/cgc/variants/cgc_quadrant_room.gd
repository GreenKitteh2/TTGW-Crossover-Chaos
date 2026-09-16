extends Node3D

func reset() -> void:
	if Util.get_player().stats.hp > 0:
		Util.circle_in(1.0)
		
		Util.get_player().global_position = $PlayerSpawn.global_position
		await Util.get_player().teleport_in(true)
		if Util.get_player().stats.hp <= 0:
			Util.get_player().lose()
