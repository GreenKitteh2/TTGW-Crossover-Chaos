extends CogAttack

const AD_EFFECT := preload("res://objects/battle/effects/adware/adware.tscn")
const SFX_ADS := preload("res://audio/sfx/battle/cogs/attacks/crossover/adware.ogg")
const AD_BLOCKER_EFFECT := preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_ad_blocker.tres")

var ads: StatusEffect

func action() -> void:
	# Variable setup
	var player : Player = targets[0]
	var cog : Cog = user
	var hit := manager.roll_for_accuracy(self)
	var blanket := AD_EFFECT.instantiate()

	# Movie Start
	var movie := manager.create_tween()
	
	# Focus Cog
	movie.tween_callback(battle_node.focus_character.bind(cog))
	movie.tween_callback(cog.set_animation.bind('effort'))
	movie.tween_callback(AudioManager.play_sound.bind(SFX_ADS))
	movie.tween_interval(0.5)
	
	# Add effect blanket
	movie.tween_callback(cog.add_child.bind(blanket))
	movie.tween_callback(blanket.set_position.bind(Vector3(0.0, 0.8, 1.42)))
	movie.tween_callback(blanket.set_rotation_degrees.bind(Vector3(30.0, 0.0, 0.0)))
	movie.tween_interval(0.5)
	
	
	# Move to player focus and switch effects
	movie.tween_callback(set_camera_angle.bind('SIDE_RIGHT'))
	
	# Set player anim to duck if dodged
	if not hit:
		movie.parallel().tween_callback(player.set_animation.bind('duck'))
		movie.parallel().tween_callback(manager.battle_text.bind(player, "MISSED"))
	else:
		movie.parallel().tween_callback(player.set_animation.bind('cringe')).set_delay(0.5)
		ads = AD_BLOCKER_EFFECT.duplicate(true)
		ads.target = player
		manager.add_status_effect(ads)
	
	
	movie.tween_callback(blanket.queue_free)
	
	movie.tween_interval(3.0)
	
	await movie.finished
	movie.kill()
	
	await manager.check_pulses(targets)
