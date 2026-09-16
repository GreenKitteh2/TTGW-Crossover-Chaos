extends CogAttack
const COG := preload('res://objects/cog/cog.tscn')

const PHRASES := [
	"To the Don!",
	"In honor of my fallen Satellites.",
	"Suits like us gotta look out for each other."
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
	var cog: Cog = user
	var target : Cog = targets[0]
	
	var health_steal := (target.stats.max_hp / 9)
	var heal_amount := -(target.stats.max_hp / 4)
	
	var movie := manager.create_tween()
	
	# Focus user
	manager.show_action_name("Tribute!", "Gives up some health to a Cog.")
	var phrase_choice: String = RandomService.array_pick_random('true_random', PHRASES)
	movie.tween_callback(cog.speak.bind(phrase_choice))
	battle_node.focus_cogs()
	battle_node.battle_cam.position.z += 3.0
	movie.tween_callback(cog.set_animation.bind('cigar-smoke'))
	movie.tween_interval(2.0)
	
	# Focus target
	var dialogue_choice: String = RandomService.array_pick_random('true_random', response_lines)
	movie.tween_callback(target.speak.bind(dialogue_choice))
	movie.tween_callback(target.set_animation.bind('buffed'))
	movie.tween_callback(manager.affect_target.bind(cog, health_steal))
	movie.tween_callback(manager.affect_target.bind(target, heal_amount))
	movie.tween_interval(3.0)
	
	# Cleanup
	await movie.finished
	movie.kill()
