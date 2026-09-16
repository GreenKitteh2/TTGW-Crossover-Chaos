extends CogAttack

const BOOST_AMT := 0.1

const STAT_BOOST_REFERENCE := preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_stat_boost.tres")

func action() -> void:
	var cog: Cog = user
	apply_boost(cog)

	var heal_amount := -(cog.stats.max_hp / (6 - manager.cogs.size()))
	
	var tween := manager.create_tween()
	tween.tween_callback(battle_node.focus_character.bind(cog))
	tween.tween_callback(cog.set_animation.bind('victory'))
	tween.tween_callback(manager.affect_target.bind(cog, heal_amount))
	tween.tween_callback(func(): AudioManager.play_sound(load("res://audio/sfx/battle/cogs/attacks/special/SA_life_insurance.ogg")))
	tween.tween_interval(10.0)
	
	await tween.finished
	tween.kill()

func apply_boost(cog : Cog) -> void:
	var new_boost := STAT_BOOST_REFERENCE.duplicate(true)
	
	new_boost.quality = StatusEffect.EffectQuality.POSITIVE
	
	new_boost.stat = "damage"
	new_boost.boost = (0.05 * manager.cogs.size())
	new_boost.rounds = -1
	new_boost.target = cog
	
	manager.add_status_effect(new_boost)
