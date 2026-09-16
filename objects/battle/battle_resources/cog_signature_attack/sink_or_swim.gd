extends CogAttack

const SOS_REFERENCE := preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_sink_or_swim.tres")

func action() -> void:
	var cog: Cog = user
	apply_boost(cog)
	
	var tween := manager.create_tween()
	tween.tween_callback(battle_node.focus_character.bind(cog))
	tween.tween_callback(cog.set_animation.bind('effort'))
	tween.tween_interval(5.0)
	
	await tween.finished
	tween.kill()

func apply_boost(cog : Cog) -> void:
	var new_boost := SOS_REFERENCE.duplicate(true)
	
	new_boost.quality = StatusEffect.EffectQuality.POSITIVE

	new_boost.rounds = 1
	new_boost.target = cog
	
	manager.add_status_effect(new_boost)
