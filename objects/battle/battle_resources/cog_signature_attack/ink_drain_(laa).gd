extends CogAttack

const INK_DRAIN_EFFECT := preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_ink_drain_(laa).tres")

var ink_drain: StatusEffect


func action() -> void:
	var cog: Cog = user
	var player : Player = targets[0]

	ink_drain = INK_DRAIN_EFFECT.duplicate(true)
	ink_drain.target = player
	manager.add_status_effect(ink_drain)
	var tween := manager.create_tween()
	tween.tween_callback(battle_node.focus_character.bind(cog))
	tween.tween_callback(cog.set_animation.bind('effort'))
	tween.tween_interval(3.0)
	tween.tween_callback(battle_node.focus_character.bind(player))
	tween.tween_callback(player.set_animation.bind('cringe'))
	tween.tween_interval(4.0)
	
	await tween.finished
	tween.kill()
