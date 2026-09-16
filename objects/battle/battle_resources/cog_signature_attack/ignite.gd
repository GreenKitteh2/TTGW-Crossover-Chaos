extends CogAttack

const FIRE_BLANKET_EFFECT := preload("res://objects/battle/effects/fire/fire_effect.tscn")
const FIRE_TRIP_EFFECT := preload("res://objects/battle/effects/fire/fire_bar.tscn")
const FIRE = preload("res://objects/battle/effects/fire/fire.tscn")
const FIRE_BURST := preload("res://objects/battle/effects/fire/fireburst.tscn")
const SFX_FLAMES := preload("res://audio/sfx/battle/cogs/attacks/SA_hot_air.ogg")
const BURNING_EFFECT := preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_burning.tres")

var burning: StatusEffect

func action() -> void:
	# Variable setup
	var player : Player = targets[0]
	var cog : Cog = user
	var hit := manager.roll_for_accuracy(self)
	var blanket := FIRE_BLANKET_EFFECT.instantiate()
	var trip := FIRE_TRIP_EFFECT.instantiate()
	trip.emitting = false
	cog.add_child(trip)
	
	# Movie Start
	var movie := manager.create_tween()
	
	# Focus Cog
	movie.tween_callback(battle_node.focus_character.bind(cog))
	movie.tween_callback(cog.set_animation.bind('magic1'))
	movie.tween_callback(AudioManager.play_sound.bind(SFX_FLAMES))
	movie.tween_interval(0.5)
	
	# Add effect blanket
	movie.tween_callback(cog.add_child.bind(blanket))
	movie.tween_callback(blanket.set_position.bind(Vector3(0.0, 0.8, 1.42)))
	movie.tween_callback(blanket.set_rotation_degrees.bind(Vector3(30.0, 0.0, 0.0)))
	movie.tween_interval(0.5)
	
	
	# Move to player focus and switch effects
	movie.tween_callback(set_camera_angle.bind('SIDE_RIGHT'))
	movie.tween_callback(trip.set_emitting.bind(true))
	movie.tween_callback(trip.set_position.bind(Vector3(0.0, 0.0, 2.33)))
	
	# Move trip effect
	var destination := player.toon.to_global(player.toon.position - Vector3(0.0, 0.0, 1.0))
	movie.tween_property(trip, 'global_position', destination, 0.75)
	
	# Set player anim to jump if dodged
	if not hit:
		movie.parallel().tween_callback(player.set_animation.bind('jump'))
		movie.parallel().tween_callback(manager.battle_text.bind(player, "MISSED"))
	else:
		movie.parallel().tween_callback(manager.affect_target.bind(player, damage)).set_delay(0.5)
		movie.parallel().tween_callback(player.set_animation.bind('cringe')).set_delay(0.5)
		movie.parallel().tween_callback(manager.battle_text.bind(player, "On fire!")).set_delay(1.0)
		burning = BURNING_EFFECT.duplicate(true)
		burning.amount = damage
		burning.target = player
		manager.add_status_effect(burning)
	
	
	movie.tween_callback(trip.queue_free)
	movie.tween_callback(blanket.queue_free)
	
	movie.tween_interval(3.0)
	
	await movie.finished
	movie.kill()
	
	await manager.check_pulses(targets)
