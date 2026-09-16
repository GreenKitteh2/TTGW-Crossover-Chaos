extends FloorModifier

func modify_floor() -> void:
	var player := Util.get_player()
	player.stats.crossover_chance_boost = 0.5


func clean_up() -> void:
	var player := Util.get_player()
	player.stats.crossover_chance_boost = 0.0

func get_mod_name() -> String:
	return "Crossover Conundrum"

func get_mod_quality() -> ModType:
	return ModType.NEGATIVE

func get_mod_icon() -> Texture2D:
	return load("res://ui_assets/player_ui/pause/Crossover_cogs.png")

func get_description() -> String:
	return "Chances of crossover Cogs have increased."
