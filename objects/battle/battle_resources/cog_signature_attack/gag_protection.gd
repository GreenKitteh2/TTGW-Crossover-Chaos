extends CogAttack

const IMMUNITY_RESOURCE := preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_gag_immunity.tres")

var boost_effects: Array[StatusEffect] = []
var track: Track
var player: Player:
	get: return Util.get_player()
	
func action() -> void:
	var cog: Cog = user
	roll_for_track()
	apply_to_cog(cog)
	
	var tween := manager.create_tween()
	tween.tween_callback(battle_node.focus_character.bind(cog))
	tween.tween_callback(cog.set_animation.bind('buffed'))
	tween.tween_interval(5.0)
	
	await tween.finished
	tween.kill()

func roll_for_track() -> void:
	track = player.stats.character.gag_loadout.loadout.pick_random()

func apply_to_cog(cog: Cog) -> void:
	var new_boost := create_boost(cog)
	manager.add_status_effect(new_boost)
	boost_effects.append(new_boost)

func create_boost(who: Cog) -> StatusEffectGagImmunity:
	var status_effect: StatusEffectGagImmunity = IMMUNITY_RESOURCE.duplicate(true)
	status_effect.target = who
	status_effect.track = track
	status_effect.rounds = 2
	status_effect.quality = StatusEffect.EffectQuality.POSITIVE
	return status_effect

func end_boost() -> void:
	for effect in boost_effects:
		if effect.target in manager.battle_stats.keys():
			manager.expire_status_effect(effect)
