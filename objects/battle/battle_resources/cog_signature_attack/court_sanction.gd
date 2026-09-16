extends CogAttack

func action():
	# Begin
	user.set_animation('finger-wag')
	manager.s_focus_char.emit(user)
	var target = targets[0]
	user.face_position(target.global_position)
	
	# Start particles after pause
	await manager.sleep(1.2)
	AudioManager.play_sound(load('res://audio/sfx/battle/cogs/attacks/SA_finger_wag.ogg'))
	
	# Additional pause
	await manager.sleep(0.75)
	manager.s_focus_char.emit(target)
	
	# Roll for accuracy
	var hit := manager.roll_for_accuracy(self)
	if hit:
		manager.affect_target(target, damage)
		target.set_animation('slip-backward')
	else:
		manager.battle_text(target,"MISSED")
		target.set_animation('sidestep-left')
	
	# Stop particles after pause
	await manager.sleep(0.5)
	
	# Cleanup
	await manager.barrier(target.animator.animation_finished, 4.0)
	
	await manager.check_pulses(targets)
	
