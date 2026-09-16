extends CogAttack

const JELLYBEAN := preload('res://objects/items/custom/jellybean/blue_jellybean.tscn')
const BEAN_STAT := preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_diminishing_returns.tres")

@export var do_money_steal := false


func action():
	# Setup
	var hit := manager.roll_for_accuracy(self)
	var tracks : Array[String] = []
	var loadout := Util.get_player().stats.character.gag_loadout.loadout
	for gagtrack in loadout:
		tracks.append(gagtrack.track_name)
	var steal_track: String = tracks.pick_random()
	var target : Player = targets[0]
	user.face_position(target.global_position)
			
	AudioManager.play_sound(load('res://audio/sfx/battle/cogs/attacks/SA_pick_pocket.ogg'))
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
		target.stats.gag_balance[steal_track] -= 3
	else:
		manager.battle_text(target,"MISSED")
	
	await manager.barrier(user.animator.animation_finished, 4.0)
	
	await manager.check_pulses(targets)
