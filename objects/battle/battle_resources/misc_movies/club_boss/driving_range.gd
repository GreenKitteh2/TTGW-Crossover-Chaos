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
const BOOST_AMOUNT := 0.5
func create_status_effects(target: Cog) -> void:
	for stat in AFFECTED_STATS:
		var stat_boost := STAT_BOOST.duplicate()
		stat_boost.stat = stat
		stat_boost.boost = BOOST_AMOUNT
		stat_boost.target = target
		stat_boost.rounds = 2
		stat_boost.quality = StatusEffect.EffectQuality.POSITIVE
		manager.add_status_effect(stat_boost)
