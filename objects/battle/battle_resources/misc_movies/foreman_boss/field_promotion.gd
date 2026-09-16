extends CogAttack

const STAT_BOOST := preload('res://objects/battle/battle_resources/status_effects/resources/status_effect_stat_boost.tres')

func action() -> void:
	var cog : Cog = user
	var target : Cog = targets[0]
	
	# MOVIE START
	var movie := manager.create_tween()
	
	# Focus user
	movie.tween_callback(battle_node.focus_character.bind(cog))
	movie.tween_callback(cog.set_animation.bind('speak'))
	movie.tween_callback(cog.face_position.bind(target.global_position))
	movie.tween_callback(create_status_effects.bind(target))
	movie.tween_interval(5.0)
	
	# Cleanup
	await movie.finished
	movie.kill()

const AFFECTED_STATS := ['damage']
const REMOVABLE_STATS := ['defense']
const BOOST_AMOUNT := 1.5
const BOOST_DEDUCT := 0.5
func create_status_effects(target: Cog) -> void:
	for stat in AFFECTED_STATS:
		var stat_boost := STAT_BOOST.duplicate()
		stat_boost.stat = stat
		stat_boost.boost = BOOST_AMOUNT
		stat_boost.target = target
		stat_boost.rounds = 2
		stat_boost.quality = StatusEffect.EffectQuality.POSITIVE
		manager.add_status_effect(stat_boost)
	for stat in REMOVABLE_STATS:
		var stat_deduct := STAT_BOOST.duplicate()
		stat_deduct.stat = stat
		stat_deduct.boost = BOOST_DEDUCT
		stat_deduct.target = target
		stat_deduct.rounds = 2
		stat_deduct.quality = StatusEffect.EffectQuality.NEGATIVE
		manager.add_status_effect(stat_deduct)
