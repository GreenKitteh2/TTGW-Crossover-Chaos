extends CogAttack

const CLOCK_EFFECT := preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_clocked.tres")
var SFX := preload("res://audio/sfx/battle/cogs/attacks/special/contractlimit_audio.ogg")

var clocked: StatusEffect


func action() -> void:
	var cog: Cog = user
	var player : Player = targets[0]

	clocked = CLOCK_EFFECT.duplicate(true)
	clocked.target = player
	manager.add_status_effect(clocked)
	var tween := manager.create_tween()
	tween.tween_callback(battle_node.focus_character.bind(cog))
	tween.parallel().tween_callback(AudioManager.play_sound.bind(SFX))
	tween.tween_callback(cog.set_animation.bind('times-up'))
	tween.tween_interval(5.0)
	
	await tween.finished
	tween.kill()
