extends CogAttack

const FROZEN_EFFECT := preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_frozen.tres")

@export var particles : PackedScene
@export var sfx : AudioStream

enum AnimName {
	GLOWER,
	EFFORT,
	MAGIC1
}
@export var animation := AnimName.GLOWER
@export var melt_toon := false

func action():
	# Setup
	var target = targets[0]
	user.face_position(target.global_position)
	var hit := manager.roll_for_accuracy(self)
	manager.s_focus_char.emit(user)
	user.set_animation(str(AnimName.keys()[animation]).to_lower())
	var cloud : Node3D = load('res://models/props/cog_props/cloud/cloud.tscn').instantiate()
	user.add_child(cloud)
	cloud.top_level = true
	cloud.global_position = user.head_node.global_position
	cloud.global_position.y+=1.0
	cloud.scale/=100.0
	
	var grow_tween : Tween = cloud.create_tween()
	var destination := Vector3(target.global_position.x,target.head_node.global_position.y+1.0,target.global_position.z)
	grow_tween.tween_property(cloud,'scale',Vector3(1,1,1),1.0)
	grow_tween.tween_interval(0.5)
	grow_tween.tween_property(cloud,'global_position',destination,1.0)
	await grow_tween.finished
	grow_tween.kill()
	
	if sfx:
		AudioManager.play_sound(sfx)
	var particle_effect : Node3D
	if particles: 
		particle_effect = particles.instantiate()
		cloud.add_child(particle_effect)
	
	manager.s_focus_char.emit(target)
	if hit:
		manager.affect_target(target, damage)
		manager.battle_text(target,"Frozen")
		target.set_animation('duck')
		apply_frozen()
	else:
		manager.battle_text(target,"MISSED")
		target.set_animation('sidestep-left')
	await target.animator.animation_finished
	
	cloud.queue_free()
	
	target.set_animation('neutral')
	
	await manager.check_pulses(targets)

	
func apply_frozen() -> void:
	var effect := FROZEN_EFFECT.duplicate(true)
	effect.target = targets[0]
	effect.rounds = 3
	manager.add_status_effect(effect)
