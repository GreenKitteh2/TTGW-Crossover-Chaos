extends FloorModifier

const BATTLE_TIME := 20
const SKELE_CHANCE := 1

func modify_floor() -> void:
	game_floor.s_cog_spawned.connect(on_cog_spawned)

func clean_up() -> void:
	game_floor.s_cog_spawned.disconnect(on_cog_spawned)

func on_cog_spawned(cog: Cog) -> void:
	if RNG.channel(RNG.ChannelDoubleTroublev2).randf() < SKELE_CHANCE:
		cog.skelecog = true
		cog.virtual_cog = true
		print('Virtual Cog spawned')
	else:
		print('Virtual Cog not spawned, how is that possible')

func get_mod_name() -> String:
	return "Virtual Cogsanity"

func get_mod_icon() -> Texture2D:
	return load("res://ui_assets/player_ui/pause/virtual.png")

func get_description() -> String:
	return "All Cogs are Virtual Cogs"

func get_mod_quality() -> ModType:
	return ModType.NEUTRAL
