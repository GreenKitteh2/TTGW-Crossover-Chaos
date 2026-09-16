extends FloorModifier

const BATTLE_TIME := 20
const V2_CHANCE := 1

func modify_floor() -> void:
	game_floor.s_cog_spawned.connect(on_cog_spawned)

func clean_up() -> void:
	game_floor.s_cog_spawned.disconnect(on_cog_spawned)

func on_cog_spawned(cog: Cog) -> void:
	if cog.dna or cog.skelecog:
		return
	if RNG.channel(RNG.ChannelDoubleTroublev2).randf() < V2_CHANCE:
		cog.v2 = true
		cog.skelecog_chance = 0
		print('v2.0 spawned')
	else:
		print('v2.0 not spawned')

func get_mod_name() -> String:
	return "Double Overtime"

func get_mod_icon() -> Texture2D:
	return load("res://ui_assets/player_ui/pause/second_skin.png")

func get_description() -> String:
	return "All Cogs are v2.0"

func get_mod_quality() -> ModType:
	return ModType.SUPERNEGATIVE
