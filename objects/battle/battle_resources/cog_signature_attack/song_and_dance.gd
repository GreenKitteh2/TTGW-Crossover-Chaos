extends CogAttack

const OVERTIME_REFERENCE := preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_overtime.tres")

func action() -> void:
	var cog: Cog = user
	apply_boost(cog)
	
	var tween := manager.create_tween()
	tween.tween_callback(battle_node.focus_character.bind(cog))
	tween.tween_callback(cog.set_animation.bind('song-and-dance'))
	for target in targets:
		tween.tween_callback(apply_boost.bind(target))
	tween.tween_interval(5.0)
	
	await tween.finished
	tween.kill()

func apply_boost(target : Cog) -> void:
	var new_boost := OVERTIME_REFERENCE.duplicate(true)
	
	new_boost.quality = StatusEffect.EffectQuality.POSITIVE

	new_boost.rounds = 1
	new_boost.target = target
	
	manager.add_status_effect(new_boost)
