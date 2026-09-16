extends ItemScript

func on_collect(_item : Item, _node : Node3D) -> void:
	var game_floor : GameFloor = Util.floor_manager
	if not is_instance_valid(game_floor):
		return
	
	for anomaly in game_floor.anomalies.duplicate(true):
		if anomaly.get_mod_quality() == FloorModifier.ModType.NEGATIVE:
			Util.get_player().stats.defense = Util.get_player().stats.defense + 0.1
		if anomaly.get_mod_quality() == FloorModifier.ModType.SUPERNEGATIVE:
			Util.get_player().stats.defense = Util.get_player().stats.defense + 0.25
