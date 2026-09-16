extends CogAttack

const STATUS_EFFECT := preload('res://objects/battle/battle_resources/status_effects/resources/status_effect_challenge.tres')

var response_lines: Array[String] = [
	"Yes Atticus!",
	"I will not fail you.",
	"As you wish Sir Atticus..."
]
func action() -> void:
	var cog : Cog = user
	var target : Cog = targets[0]
	
	# MOVIE START
	var movie := manager.create_tween()
	
	# Focus user
	movie.tween_callback(battle_node.focus_character.bind(cog))
	movie.tween_callback(cog.set_animation.bind('speak'))
	movie.tween_callback(cog.face_position.bind(target.global_position))
	movie.tween_interval(5.0)
	
	# Focus target
	var dialogue_choice: String = RandomService.array_pick_random('true_random', response_lines)
	movie.tween_callback(target.speak.bind(dialogue_choice))
	movie.tween_callback(battle_node.focus_character.bind(target))
	var effect := STATUS_EFFECT.duplicate()
	effect.target = target
	manager.add_status_effect(effect)
	movie.tween_callback(manager.battle_text.bind(target, "+1 Turn!", BattleText.colors.orange[0], BattleText.colors.orange[1]))
	movie.tween_interval(2.0)
	movie.tween_callback(manager.battle_text.bind(target, "Damage Up!", BattleText.colors.orange[0], BattleText.colors.orange[1]))
	movie.tween_interval(3.0)
	
	# Cleanup
	await movie.finished
	movie.kill()
