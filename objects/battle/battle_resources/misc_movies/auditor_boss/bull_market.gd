extends CogAttack

const STATUS_EFFECT := preload('res://objects/battle/battle_resources/status_effects/resources/auditor_bull_market.tres')
const BULL_MUSIC := preload("res://audio/music/ttr_s_ara_chq_facilityBossBull.ogg")

func action() -> void:
	var cog : Cog = user
	AudioManager.set_music(BULL_MUSIC)
	
	# MOVIE START
	var movie := manager.create_tween()
	
	# Focus user
	movie.tween_callback(battle_node.focus_character.bind(cog))
	movie.tween_callback(cog.set_animation.bind('buffed'))
	movie.tween_callback(create_status_effects.bind(cog))
	movie.tween_interval(5.0)
	
	# Cleanup
	await movie.finished
	movie.kill()

func create_status_effects(target: Cog) -> void:
	var effect := STATUS_EFFECT.duplicate()
	effect.target = user
	manager.add_status_effect(effect)
