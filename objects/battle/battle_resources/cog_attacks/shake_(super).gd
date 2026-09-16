extends CogAttack

enum AnimType {
	JUMP,
	STOMP
}
@export var anim_type := AnimType.JUMP

const BOOST_AMT := 0.1

const STAT_BOOST_REFERENCE := preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_stat_boost.tres")

func action() -> void:
	# Setup
	var target : Player = targets[0]
	user.face_position(target.global_position)
	
	# Do animation
	manager.s_focus_char.emit(user)
	if anim_type == AnimType.JUMP:
		user.set_animation('jump')
	else:
		user.set_animation('stomp')
	await manager.sleep(1.75)
	
	# Roll for accuracy
	manager.s_focus_char.emit(targets[0])
	var hit := manager.roll_for_accuracy(self)
	
	# Affect toon. Or don't
	var anim := ''
	if hit:
		anim = 'slip-forward'
		apply_boost()
		manager.affect_target(target, damage)
	else:
		manager.battle_text(target,"MISSED")
		anim = 'jump'
	
	# Play animation (twice)
	for i in 2:
		Util.shake_camera(battle_node.battle_cam, 1.0, 0.2)
		target.set_animation(anim)
		target.toon.anim_seek(0.0)
		await manager.barrier(target.animator.animation_finished, 5.0)

	await manager.check_pulses(targets)
	
func apply_boost() -> void:
	var new_boost := STAT_BOOST_REFERENCE.duplicate(true)
	
	new_boost.quality = StatusEffect.EffectQuality.POSITIVE
	
	new_boost.stat = "damage"
	new_boost.boost = BOOST_AMT
	new_boost.rounds = -1
	new_boost.target = user
	
	manager.add_status_effect(new_boost)
