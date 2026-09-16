extends FloorModifier

func modify_floor() -> void:
	game_floor.s_cog_spawned.connect(on_cog_spawned)
	Globals.PROXY_CHANCE_MAXIMUM = 0

func clean_up() -> void:
	game_floor.s_cog_spawned.disconnect(on_cog_spawned)
	Globals.PROXY_CHANCE_MAXIMUM = 0.5

func on_cog_spawned(cog: Cog) -> void:
	cog.QUEST_HELP_CHANCE = 0 
	cog.use_crossover_cogs_pool = true
	cog.skelecog_chance = 0

func get_mod_name() -> String:
	return "Crossoverload"

func get_mod_quality() -> ModType:
	return ModType.SUPERNEGATIVE

func get_mod_icon() -> Texture2D:
	return load("res://ui_assets/player_ui/pause/crossoverload.png")

func get_description() -> String:
	return "Battles are overridden with Crossover Cogs."
