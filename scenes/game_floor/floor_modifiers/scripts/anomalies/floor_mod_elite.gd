extends FloorModifier

# UNUSED
# I have a hard time trying to make it work, not only that
# It's barely shows up and it's really bothered me :(

func modify_floor() -> void:
	game_floor.s_cog_spawned.connect(on_cog_spawned)

func clean_up() -> void:
	game_floor.s_cog_spawned.disconnect(on_cog_spawned)


func on_cog_spawned(cog: Cog) -> void:
	cog.intern_chance = 0
	cog.elite_chance = 0
	if cog.use_crossover_cogs_pool:
		print("Crossover Cog detected")
		cog.pool = Globals.ELITE_COG_POOL

func get_mod_name() -> String:
	return "Elite Enforcement"

func get_mod_quality() -> ModType:
	return ModType.NEGATIVE

func get_mod_icon() -> Texture2D:
	return load("res://ui_assets/player_ui/pause/elite.png")

func get_description() -> String:
	return "All Crossover Cogs are Elites"
