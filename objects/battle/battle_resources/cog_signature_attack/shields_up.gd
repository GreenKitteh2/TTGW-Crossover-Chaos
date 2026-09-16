extends CogAttack
const COG := preload('res://objects/cog/cog.tscn')

const PHRASES := [
	"I can take it!!",
	"M' guard's up!!",
	"'S just a scratch!!",
	"That the best y’all got!?"
]

const STAND_UP_REFERENCE := preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_shields_up.tres")


func action() -> void:
	if len(manager.cogs) <= 1:
		return
		
	var cog_user: Cog = user
	
	var movie := manager.create_tween()
	
	# Focus user
	var phrase_choice: String = RandomService.array_pick_random('true_random', PHRASES)
	movie.tween_callback(cog_user.speak.bind(phrase_choice))
	movie.tween_callback(func(): AudioManager.play_sound(load("res://audio/sfx/battle/cogs/attacks/special/SA_defense.ogg")))
	battle_node.focus_character(cog_user)
	movie.tween_callback(cog_user.set_animation.bind('effort'))
	movie.tween_interval(3.0)
	
	# Focus target
	movie.tween_callback(create_stand_up.bind(cog_user))
	movie.tween_interval(3.0)
	
	# Cleanup
	await movie.finished
	movie.kill()

func create_stand_up(target: Cog) -> void:
	var mod_effect:= STAND_UP_REFERENCE.duplicate(true)
	mod_effect.target = target
	mod_effect.scapegoat = user
	manager.add_status_effect(mod_effect)
