extends CogAttack

const BOOST_AMT := 0.5

const STAT_BOOST_REFERENCE := preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_stat_boost.tres")



func action() -> void:
	var cog: Cog = user
	apply_boost(cog)
	
	var tween := manager.create_tween()
	tween.tween_callback(func(): AudioManager.play_sound(load("res://audio/sfx/battle/cogs/attacks/special/SA_rage.ogg")))
	tween.tween_callback(battle_node.focus_character.bind(cog))
	tween.tween_callback(manager.battle_text.bind(cog, "Damage Up!", BattleText.colors.orange[0], BattleText.colors.orange[1]))
	tween.tween_callback(cog.set_animation.bind('buffed'))
	tween.tween_interval(3.0)
	
	await tween.finished
	tween.kill()

func apply_boost(cog : Cog) -> void:
	var new_boost := STAT_BOOST_REFERENCE.duplicate(true)
	
	new_boost.quality = StatusEffect.EffectQuality.POSITIVE
	
	new_boost.stat = "damage"
	new_boost.boost = BOOST_AMT
	new_boost.rounds = 3
	new_boost.target = cog
	
	manager.add_status_effect(new_boost)
