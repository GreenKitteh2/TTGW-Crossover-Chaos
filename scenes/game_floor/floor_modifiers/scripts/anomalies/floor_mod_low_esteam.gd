extends FloorModifier

const NERF_AMT_PLAYER := -0.50

var status_effect: StatBoost:
	get: return GameLoader.load("res://objects/battle/battle_resources/status_effects/resources/status_effect_stat_boost.tres").duplicate(true)

func modify_floor() -> void:
	var player := Util.get_player()
	player.stats.defense += NERF_AMT_PLAYER
func clean_up() -> void:
	var player := Util.get_player()
	player.stats.defense -= NERF_AMT_PLAYER

func get_mod_name() -> String:
	return "Low Self-esteem"

func get_mod_icon() -> Texture2D:
	return load("res://ui_assets/player_ui/pause/low_esteem.png")

func get_description() -> String:
	return "You receive -50% Defense"

func get_mod_quality() -> ModType:
	return ModType.SUPERNEGATIVE
