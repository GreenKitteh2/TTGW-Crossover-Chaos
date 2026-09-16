extends CogAttack
const COG := preload('res://objects/cog/cog.tscn')

const STATUS_EFFECT := preload('res://objects/battle/battle_resources/status_effects/resources/status_effect_auto_repair.tres')

const PHRASES := [
	"Try this, It's useful",
	"I got a special modification just for you.",
	"This should keep you in the game."
]

var response_lines: Array[String] = [
	"Niche feature, I'll take it.",
	"I appreciate it.",
	"I'll take the upgrade."
]

func action() -> void:
	if len(manager.cogs) <= 1:
		return
	var cog: Cog = user
	var target : Cog = targets[0]

	
	var heal_amount := -(cog.stats.max_hp / 6)
	
	var movie := manager.create_tween()
	
	# Focus user
	manager.show_action_name("Auto Repair!", "Grants a Cog health regeneration")
	var phrase_choice: String = RandomService.array_pick_random('true_random', PHRASES)
	movie.tween_callback(cog.speak.bind(phrase_choice))
	movie.tween_callback(battle_node.focus_character.bind(cog))
	movie.tween_callback(func(): AudioManager.play_sound(load("res://audio/sfx/battle/gags/lure/TL_presentation.ogg")))
	movie.tween_callback(cog.set_animation.bind('magic1'))
	movie.tween_callback(cog.face_position.bind(target.global_position))
	movie.tween_interval(3.0)
	
	# Focus target
	var dialogue_choice: String = RandomService.array_pick_random('true_random', response_lines)
	movie.tween_callback(target.speak.bind(dialogue_choice))
	movie.tween_callback(apply_effect)
	movie.tween_callback(battle_node.focus_character.bind(target))
	movie.tween_callback(manager.affect_target.bind(target, heal_amount))
	movie.tween_interval(3.0)
	
	# Cleanup
	await movie.finished
	movie.kill()

func apply_effect() -> void:
	var effect := STATUS_EFFECT.duplicate()
	effect.target = targets[0]
	manager.add_status_effect(effect)
