extends FloorModifier

var level_change_vector: Vector2i

## Increases the Cog level min/max for the floor
func modify_floor() -> void:
	level_change_vector = Vector2(0, 6)
	game_floor.level_range += level_change_vector

func get_mod_name() -> String:
	return "Hard Mode"

func get_mod_quality() -> ModType:
	return ModType.NEGATIVE

func get_mod_icon() -> Texture2D:
	return load("res://ui_assets/player_ui/pause/tightened_security.png")

func get_description() -> String:
	return "You did this to yourself bro"
