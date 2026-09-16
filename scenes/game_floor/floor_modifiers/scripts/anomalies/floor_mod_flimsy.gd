extends FloorModifier

const NERF_AMT_COGS := -0.25

var status_effect: StatBoost:
	get: return GameLoader.load("res://objects/battle/battle_resources/status_effects/resources/status_effect_stat_boost.tres").duplicate(true)

func modify_floor() -> void:
	game_floor.s_cog_spawned.connect(on_cog_spawned)

func clean_up() -> void:
	game_floor.s_cog_spawned.disconnect(on_cog_spawned)

func on_cog_spawned(cog: Cog) -> void:
	cog.s_dna_set.connect(on_dna_set.bind(cog))

func on_dna_set(cog: Cog) -> void:
	var effect := status_effect
	effect.boost = NERF_AMT_COGS
	effect.rounds = -1
	effect.quality = StatusEffect.EffectQuality.NEGATIVE
	effect.stat = 'damage'
	cog.status_effects.append(effect)
	pass
	
func get_mod_name() -> String:
	return "Bare Minimum Wage"

func get_mod_icon() -> Texture2D:
	return load("res://ui_assets/player_ui/pause/flimsy.png")

func get_description() -> String:
	return "Cogs receives -25% Damage"

func get_mod_quality() -> ModType:
	return ModType.POSITIVE
