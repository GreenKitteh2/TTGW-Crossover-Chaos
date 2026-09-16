extends CogAttack
const COG := preload('res://objects/cog/cog.tscn')

const BOOST_AMT := 0.25

const STAT_BOOST_REFERENCE := preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_stat_boost.tres")

const PHRASES := [
	"You got this my friend!",
	"You can do it better if you put your mind to it.",
	"Us Cogs are strong.",
	"May the work force be with you!"	
]

var response_lines: Array[String] = [
	"I'll do my best!",
	"A leg up I needed.",
	"Good morale talk."
]

func action() -> void:
	if len(manager.cogs) <= 1:
		return
	var cog: Cog = user
	var target : Cog = targets[0]
	
	var movie := manager.create_tween()
	
	# Focus user
	manager.show_action_name("Encourage!", "Grants a Cog damage boost")
	var phrase_choice: String = RandomService.array_pick_random('true_random', PHRASES)
	movie.tween_callback(cog.speak.bind(phrase_choice))
	movie.tween_callback(battle_node.focus_character.bind(cog))
	movie.tween_callback(cog.set_animation.bind('speak'))
	movie.tween_callback(cog.face_position.bind(target.global_position))
	movie.tween_interval(3.0)
	
	# Focus target
	var dialogue_choice: String = RandomService.array_pick_random('true_random', response_lines)
	movie.tween_callback(target.speak.bind(dialogue_choice))
	movie.tween_callback(target.set_animation.bind('buffed'))
	movie.tween_callback(apply_boost)
	movie.tween_callback(battle_node.focus_character.bind(target))
	movie.tween_interval(3.0)
	
	# Cleanup
	await movie.finished
	movie.kill()

func apply_boost() -> void:
	var new_boost := STAT_BOOST_REFERENCE.duplicate(true)
	
	new_boost.quality = StatusEffect.EffectQuality.POSITIVE
	
	new_boost.stat = "damage"
	new_boost.boost = BOOST_AMT
	new_boost.rounds = 3
	new_boost.target = targets[0]
	
	manager.add_status_effect(new_boost)
