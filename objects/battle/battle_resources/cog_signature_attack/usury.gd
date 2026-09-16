extends CogAttack
const COG := preload('res://objects/cog/cog.tscn')

const PHRASES := [
	"These rates are astronomical!",
	"Consider this a fiscal 'black hole,' if ya will.",
	"Ya gonna be light-years away from paying your debts."
]

func action() -> void:
	if len(manager.cogs) <= 1:
		return
	var cog: Cog = user
	var target : Cog = targets[0]
	
	var health_steal := (target.stats.max_hp / 6)
	var heal_amount := -(target.stats.max_hp / 3)
	
	var movie := manager.create_tween()
	
	# Focus user
	manager.show_action_name("Usury!", "Steals a Cog's health!")
	var phrase_choice: String = RandomService.array_pick_random('true_random', PHRASES)
	movie.tween_callback(cog.speak.bind(phrase_choice))
	battle_node.focus_cogs()
	battle_node.battle_cam.position.z += 3.0
	movie.tween_callback(cog.set_animation.bind('cross'))
	movie.tween_interval(2.0)
	
	# Focus target
	movie.tween_callback(target.set_animation.bind('soak'))
	movie.tween_callback(manager.affect_target.bind(target, health_steal))
	movie.tween_callback(manager.affect_target.bind(cog, heal_amount))
	movie.tween_interval(3.0)
	
	# Cleanup
	await movie.finished
	movie.kill()
