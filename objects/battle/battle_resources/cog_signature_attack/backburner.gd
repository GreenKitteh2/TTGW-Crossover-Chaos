extends CogAttack
const COG := preload('res://objects/cog/cog.tscn')

const PHRASES := [
	"Let me turn up the heat...",
	"Let's crank up the heat.",
	"Now we're cooking with gas...",
	"You can't snuff out this battle so soon."
]

const OVERHEAT_REFERENCE := preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_overheated.tres")


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
	
	# Focus user
	manager.show_action_name("Backburner!", "Overheats other Cogs!")
	var phrase_choice: String = RandomService.array_pick_random('true_random', PHRASES)
	movie.tween_callback(cog_user.speak.bind(phrase_choice))
	battle_node.focus_cogs()
	battle_node.battle_cam.position.z += 3.0
	movie.tween_callback(cog_user.set_animation.bind('magic1'))
	movie.tween_interval(3.0)
	
	# Focus target
	for target in targets:
		movie.tween_callback(create_status_effects.bind(target))
	movie.tween_interval(3.0)
	
	# Cleanup
	await movie.finished
	movie.kill()

func create_status_effects(target: Cog) -> void:
	var mod_effect:= OVERHEAT_REFERENCE.duplicate(true)
	mod_effect.rounds = 2
	mod_effect.target = target
	manager.add_status_effect(mod_effect)
