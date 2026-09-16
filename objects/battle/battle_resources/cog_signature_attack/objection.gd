extends CogAttack

const BLANKET_EFFECT := preload("res://objects/battle/effects/guilt_trip/guilt_trip_blanket.tscn")
const TRIP_EFFECT := preload("res://objects/battle/effects/guilt_trip/guilt_trip_effect.tscn")
const SFX := preload("res://audio/sfx/battle/cogs/attacks/SA_guilt_trip.ogg")
const OBJECTION := preload("res://audio/sfx/battle/cogs/attacks/special/SA_objection.ogg")
const FAIL := preload("res://audio/sfx/battle/cogs/attacks/special/SA_objection_overruled.ogg")
const PINPOINT_REFERENCE := preload("res://objects/battle/battle_resources/status_effects/resources/mod_cog_pinpoint.tres")


func action() -> void:
	# Variable setup
	var player : Player = targets[0]
	var cog : Cog = user
	var hit := manager.roll_for_accuracy(self)
	var blanket := BLANKET_EFFECT.instantiate()
	var trip := TRIP_EFFECT.instantiate()
	trip.emitting = false
	cog.add_child(trip)
	
	var heal_amount := -(cog.stats.max_hp / 4)
	var damage_amount := (cog.stats.max_hp / 4)

	# Movie Start
	var movie := manager.create_tween()
	
	# Focus Cog
	movie.tween_callback(AudioManager.play_sound.bind(OBJECTION))
	movie.tween_callback(battle_node.focus_character.bind(cog))
	movie.tween_callback(cog.set_animation.bind('speak'))
	movie.tween_interval(6.0)
	
	
	
	# Set player anim to jump if dodged
	if not hit:
		movie.tween_callback(manager.affect_target.bind(cog, damage_amount))
		movie.tween_callback(battle_node.focus_character.bind(cog))
		movie.tween_callback(cog.speak.bind("Unbelievable."))
		movie.tween_callback(AudioManager.play_sound.bind(FAIL))
		movie.tween_callback(cog.set_animation.bind('soak'))
		movie.tween_interval(3.0)
		
		await movie.finished
		movie.kill()
	else:
		apply_boost(cog)
		movie.tween_callback(manager.affect_target.bind(cog, heal_amount))
		movie.tween_callback(cog.speak.bind("Now for my counter argument."))
		movie.tween_callback(battle_node.focus_character.bind(cog))
		movie.tween_callback(cog.set_animation.bind('magic1'))
		movie.tween_interval(0.5)
	
	# Add effect blanket
		movie.tween_callback(cog.add_child.bind(blanket))
		movie.tween_callback(blanket.set_position.bind(Vector3(0.0, 0.8, 1.42)))
		movie.tween_callback(blanket.set_rotation_degrees.bind(Vector3(30.0, 0.0, 0.0)))
		movie.tween_interval(0.5)
	
	# Play sound effect
		movie.tween_callback(AudioManager.play_sound.bind(SFX))
	
	# Move to player focus and switch effects
		movie.tween_callback(set_camera_angle.bind('SIDE_RIGHT'))
		movie.tween_callback(trip.set_emitting.bind(true))
		movie.tween_callback(trip.set_position.bind(Vector3(0.0, 0.0, 2.33)))
	
	# Move trip effect
		var destination := player.toon.to_global(player.toon.position - Vector3(0.0, 0.0, 1.0))
		movie.tween_property(trip, 'global_position', destination, 0.75)
		movie.parallel().tween_callback(manager.affect_target.bind(player, damage)).set_delay(0.5)
		movie.parallel().tween_callback(player.set_animation.bind('slip-forward')).set_delay(0.5)
		movie.tween_callback(trip.queue_free)
		movie.tween_callback(blanket.queue_free)
	
		movie.tween_interval(3.0)
		
		await movie.finished
		movie.kill()
	

	

	
	await manager.check_pulses(targets)

func apply_boost(cog : Cog) -> void:
	var new_boost := PINPOINT_REFERENCE.duplicate(true)
	
	new_boost.quality = StatusEffect.EffectQuality.POSITIVE

	new_boost.rounds = 1
	new_boost.target = cog
	
	manager.add_status_effect(new_boost)
