extends FloorModifier

const BATTLE_TIME := 20
const V3_CHANCE := 0.15
const V2_CHANCE := 0.15

func modify_floor() -> void:
	game_floor.s_cog_spawned.connect(on_cog_spawned)

func clean_up() -> void:
	game_floor.s_cog_spawned.disconnect(on_cog_spawned)

func on_cog_spawned(cog: Cog) -> void:
	if cog.dna or cog.skelecog:
		return
	if RNG.channel(RNG.ChannelDoubleTroublev2).randf() < V3_CHANCE:
		cog.v3 = true
		cog.skelecog_chance = 0
		print('v3.0 spawned')
	else:
		if RNG.channel(RNG.ChannelDoubleTroublev2).randf() < V2_CHANCE:
			cog.v2 = true
			cog.skelecog_chance = 0
			print('v2.0 spawned')
		else:
			print("Ha ha you're a normal cog")

func get_mod_name() -> String:
	return "Triple Threat"

func get_mod_icon() -> Texture2D:
	return load("res://ui_assets/player_ui/pause/triple.png")

func get_description() -> String:
	return "v3.0 and v2.0 Cogs may appear"

func get_mod_quality() -> ModType:
	return ModType.SUPERNEGATIVE
