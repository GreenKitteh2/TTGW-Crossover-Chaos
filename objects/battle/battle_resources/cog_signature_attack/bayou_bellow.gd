extends CogAttack
const COG := preload('res://objects/cog/cog.tscn')
const SFX_STOMP := preload("res://audio/sfx/battle/cogs/attacks/special/SA_bellow.ogg")

func action() -> void:
	if len(manager.cogs) <= 1:
		return
	var cog_user: Cog = user
	for i in range(targets.size() - 1, -1, -1):
		var target = targets[i]
		if not target or target.stats.hp <= 0:
			targets.remove_at(i)
	if targets.is_empty():
		manager.show_action_name("", "")
		return
	
	var movie := manager.create_tween()
	manager.show_action_name("Bayou Bellow!", "Unlures all Cogs!")
	battle_node.focus_cogs()
	battle_node.battle_cam.position.z += 3.0
	movie.tween_callback(cog_user.set_animation.bind('stomp'))
	movie.tween_callback(AudioManager.play_sound.bind(SFX_STOMP))
	movie.tween_interval(1.5)
	
	# Focus user
	for target in targets:
		if target.lured:
			movie.parallel().tween_callback(target.set_animation.bind('slip-backward')).set_delay(1.0)
			movie.parallel().tween_property(target.get_node('Body'),'position:z',0,1.0).set_delay(1.0)
			movie.parallel().tween_callback(target.set_animation.bind('neutral')).set_delay(5.0)
			manager.force_unlure(target)
	movie.tween_interval(2.0)
	
	await movie.finished
	movie.kill()
