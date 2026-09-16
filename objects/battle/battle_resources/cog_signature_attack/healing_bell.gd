extends CogAttack
const COG := preload('res://objects/cog/cog.tscn')

const PHRASES := [
	"The bell does not toll for thee just yet.",
	"Allow me to ring up some assistance.",
	"Let me chime in here....",
	"Let's fix up these bells and whistles."
]
var response_lines: Array[String] = [
	"Thank you.",
	"Much obliged.",
	"Needed that.",
	"How nice of you.",
]

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
		
	var heal_amount := -(cog_user.stats.max_hp / 4)
	
	var movie := manager.create_tween()
	
	# Focus user
	manager.show_action_name("Healing Bell!", "Heals all Cogs")
	movie.tween_callback(func(): AudioManager.play_sound(load("res://audio/sfx/battle/cogs/attacks/special/SA_healing_bell.ogg")))
	var phrase_choice: String = RandomService.array_pick_random('true_random', PHRASES)
	movie.tween_callback(cog_user.speak.bind(phrase_choice))
	battle_node.focus_cogs()
	battle_node.battle_cam.position.z += 3.0
	movie.tween_callback(cog_user.set_animation.bind('effort'))
	movie.tween_interval(3.0)
	
	# Focus target
	movie.tween_callback(func(): AudioManager.play_sound(load("res://audio/sfx/battle/cogs/attacks/crossover/snd_power.ogg")))
	for target in targets:
		var dialogue_choice: String = RandomService.array_pick_random('true_random', response_lines)
		movie.tween_callback(manager.affect_target.bind(target, -(target.stats.max_hp / 3)))
		movie.tween_callback(target.speak.bind(dialogue_choice))
	movie.tween_callback(manager.affect_target.bind(cog_user, heal_amount))	
	movie.tween_interval(3.0)
	
	# Cleanup
	await movie.finished
	movie.kill()
