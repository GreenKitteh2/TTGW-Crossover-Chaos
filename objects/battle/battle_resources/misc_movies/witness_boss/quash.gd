extends CogAttack

const STAT_BOOST := preload('res://objects/battle/battle_resources/status_effects/resources/attentive.tres')


func action() -> void:
	# FAILSAFE
	for i in range(targets.size() - 1, -1, -1):
		var target = targets[i]
		if not target or target.stats.hp <= 0:
			targets.remove_at(i)
	if targets.is_empty():
		manager.show_action_name("", "")
		return
	
	var cog: Cog = user
	
	# MOVIE START
	var movie := manager.create_tween()
	
	# Focus user
	movie.tween_callback(battle_node.focus_character.bind(cog))
	movie.tween_callback(cog.set_animation.bind('effort'))
	movie.tween_interval(3.0)
	
	# Focus Cogs
	for target in targets:
		movie.tween_callback(create_status_effects.bind(target))
	
	movie.tween_interval(3.0)
	
	await movie.finished

func create_status_effects(target: Cog) -> void:
	var stat_boost := STAT_BOOST.duplicate()
	stat_boost.target = target
	stat_boost.rounds = 2
	manager.add_status_effect(stat_boost)
