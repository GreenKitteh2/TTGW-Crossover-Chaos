extends CogAttack
const COG := preload('res://objects/cog/cog.tscn')

const PHRASES := [
	"I won't stand for your harassment anymore.",
	"Alright, that's enough. I'm takin' a stand.",
	"I can't stand seeing the rest of 'em get hurt!"
]

const DEFENSE_REFERENCE := preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_stand_up_defense.tres")
const STAND_UP_REFERENCE := preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_stand_up_guy.tres")


func action() -> void:
	if len(manager.cogs) <= 1:
		return
		
	var cog_user: Cog = user
	for i in range(targets.size() - 1, -1, -1):
		var target = targets[i]
		if not target or target.stats.hp <= 0:
			targets.remove_at(i)
	if targets.is_empty():
		manager.show_action_name("", "")
		return
	
	
	var movie := manager.create_tween()
	
	# Focus user
	var phrase_choice: String = RandomService.array_pick_random('true_random', PHRASES)
	movie.tween_callback(cog_user.speak.bind(phrase_choice))
	battle_node.focus_character(cog_user)
	movie.tween_callback(cog_user.set_animation.bind('buffed'))
	movie.tween_interval(3.0)
	
	# Focus target
	for target in targets:
		movie.tween_callback(create_status_effects.bind(target))
	movie.tween_callback(create_stand_up.bind(cog_user))
	movie.tween_interval(3.0)
	
	# Cleanup
	await movie.finished
	movie.kill()

func create_stand_up(target: Cog) -> void:
	var mod_effect:= STAND_UP_REFERENCE.duplicate(true)
	mod_effect.target = target
	mod_effect.charon = user
	manager.add_status_effect(mod_effect)
	
func create_status_effects(target: Cog) -> void:
	var mod_effect:= DEFENSE_REFERENCE.duplicate(true)
	mod_effect.target = target
	mod_effect.liability_holder = target
	manager.add_status_effect(mod_effect)
