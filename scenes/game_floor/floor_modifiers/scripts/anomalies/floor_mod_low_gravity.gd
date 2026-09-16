extends FloorModifier

const GRAVITY_MULTIPLIER := 0.75

## Lowers player gravity for the floor
func modify_floor() -> void:
	if Util.get_player():
		Util.get_player().gravity *= GRAVITY_MULTIPLIER
		game_floor.s_floor_ended.connect(func(): Util.get_player().gravity /= GRAVITY_MULTIPLIER)

func get_mod_name() -> String:
	return "Low Gravity"

func get_mod_quality() -> ModType:
	return ModType.POSITIVE
