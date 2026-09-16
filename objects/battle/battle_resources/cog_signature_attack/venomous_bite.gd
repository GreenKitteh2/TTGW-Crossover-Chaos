extends CogAttack

const POISON_EFFECT := preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_poison.tres")

var poisoned: StatusEffect

var player: Player
	
func action():
	# Setup
	var hit := manager.roll_for_accuracy(self)
	var target : Player = targets[0]
	user.face_position(target.global_position)
			
	AudioManager.play_sound(load('res://audio/sfx/items/big_chomp.ogg'))
	user.set_animation('pickpocket')
	manager.s_focus_char.emit(user)
	
	# Base toon anim on whether target was hit
	if hit:
		target.set_animation('cringe')
	else:
		target.set_animation('sidestep-left')
		
	
	# Swap camera angle after 0.5 seconds
	await manager.sleep(0.5)
	manager.s_focus_char.emit(target)
	
	# Affect target, or don't
	if hit:
		manager.affect_target(target, damage)
		await manager.sleep(0.5)
		manager.battle_text(target,"Poisoned")
		apply_poison()
	else:
		manager.battle_text(target,"MISSED")
	
	await manager.barrier(user.animator.animation_finished, 4.0)
	
	await manager.check_pulses(targets)

func apply_poison() -> void:
	var effect := POISON_EFFECT.duplicate(true)
	effect.amount = damage
	effect.target = targets[0]
	effect.rounds = 6
	manager.add_status_effect(effect)
