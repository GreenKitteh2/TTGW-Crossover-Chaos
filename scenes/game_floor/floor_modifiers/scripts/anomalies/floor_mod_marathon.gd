extends FloorModifier

const ROOM_MULTIPLIER := 1.25


## Multiplies the room count of the floor
func modify_floor() -> void:
	game_floor.room_count = floor(game_floor.room_count * ROOM_MULTIPLIER)
	if game_floor.room_count % 2 == 0:
		game_floor.room_count += 1

func get_mod_name() -> String:
	return "Marathon"

func get_mod_quality() -> ModType:
	return ModType.NEUTRAL

func get_mod_icon() -> Texture2D:
	return load("res://ui_assets/player_ui/pause/Marathon.png")

func get_description() -> String:
	return "25% longer floor"
