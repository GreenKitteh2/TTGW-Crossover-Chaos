extends CogAttack

const DIZZY_EFFECT := preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_dizzy.tres")

var dizzy: StatusEffect


func action() -> void:
	var cog: Cog = user
	var player : Player = targets[0]

	dizzy = DIZZY_EFFECT.duplicate(true)
	dizzy.target = player
	manager.add_status_effect(dizzy)
	var tween := manager.create_tween()
	tween.tween_callback(battle_node.focus_character.bind(cog))
	tween.tween_callback(cog.set_animation.bind('magic3'))
	tween.tween_interval(3.0)
	tween.tween_callback(battle_node.focus_character.bind(player))
	tween.tween_callback(player.set_animation.bind('confused'))
	tween.tween_property(player,'rotation_degrees:y',0.0,0.0)
	tween.tween_callback(func(): AudioManager.play_sound(load("res://audio/sfx/toon/avatar_emotion_confused.ogg")))
	tween.tween_property(player,'rotation_degrees:y',1080.0,2.0)
	tween.tween_interval(4.0)
	
	await tween.finished
	tween.kill()
