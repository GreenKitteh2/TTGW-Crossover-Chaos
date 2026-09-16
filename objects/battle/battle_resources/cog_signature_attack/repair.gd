extends CogAttack
const COG := preload('res://objects/cog/cog.tscn')

const PHRASES := [
	"This should fix you.",
	"You got a couple of loose screws, I'll get that.",
	"Always keep things under maintenance."
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
		
	var heal_amount := -(cog.stats.max_hp / 4)
	
	var movie := manager.create_tween()
	
	# Focus user
	manager.show_action_name("Repair!", "Heals a Cog")
	var phrase_choice: String = RandomService.array_pick_random('true_random', PHRASES)
	movie.tween_callback(cog.speak.bind(phrase_choice))
	movie.tween_callback(battle_node.focus_character.bind(cog))
	movie.tween_callback(cog.set_animation.bind('effort'))
	movie.tween_callback(cog.face_position.bind(target.global_position))
	movie.tween_interval(3.0)
	
	# Focus target
	var dialogue_choice: String = RandomService.array_pick_random('true_random', response_lines)
	movie.tween_callback(target.speak.bind(dialogue_choice))
	movie.tween_callback(func(): AudioManager.play_sound(load("res://audio/sfx/battle/cogs/attacks/crossover/snd_power.ogg")))
	movie.tween_callback(battle_node.focus_character.bind(target))
	movie.tween_callback(manager.affect_target.bind(target, heal_amount))
	movie.tween_interval(3.0)
	
	# Cleanup
	await movie.finished
	movie.kill()
