extends FloorModifier


func modify_floor() -> void:
	var env : Environment = game_floor.environment.environment.duplicate()
	env.background_energy_multiplier = 0.05
	env.ambient_light_energy = 0.05
	game_floor.environment.environment = env


func get_mod_name() -> String:
	return "Power Out"

func get_mod_quality() -> ModType:
	return ModType.NEGATIVE
