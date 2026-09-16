extends CogAttack

const MARKED_EFFECT := preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_marked.tres")

var marked: StatusEffect


func action() -> void:
	var cog: Cog = user
	var player : Player = targets[0]

	marked = MARKED_EFFECT.duplicate(true)
	marked.target = player
	manager.add_status_effect(marked)
	var tween := manager.create_tween()
	tween.tween_callback(battle_node.focus_character.bind(cog))
	tween.tween_callback(cog.set_animation.bind('effort'))
	tween.tween_interval(5.0)
	
	await tween.finished
	tween.kill()
