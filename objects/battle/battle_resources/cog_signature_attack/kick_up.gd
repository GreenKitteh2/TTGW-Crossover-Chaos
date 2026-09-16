extends CogAttack
const COG := preload('res://objects/cog/cog.tscn')

const BOOST_AMT := 0.25

const STAT_BOOST_REFERENCE := preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_stat_boost.tres")

const PHRASES := [
	"We'll get a kick out of this.",
	"Look out, this might have a bit of a kick.",
	"Ya gonna be kickin' yourself for not plannin' ahead, Toon.",
	"I bet an extra kick will send 'em flyin'."
]

func action() -> void:
	if len(manager.cogs) <= 1:
		return
	var cog: Cog = user
	var target : Cog = targets[0]
	
	var movie := manager.create_tween()
	
	# Focus user
	manager.show_action_name("Kick up!", "Grants a Cog damage boost")
	var phrase_choice: String = RandomService.array_pick_random('true_random', PHRASES)
	movie.tween_callback(cog.speak.bind(phrase_choice))
	battle_node.focus_cogs()
	battle_node.battle_cam.position.z += 3.0
	movie.tween_callback(cog.set_animation.bind('rake'))
	movie.tween_interval(1.0)
	
	# Focus target
	movie.tween_callback(target.set_animation.bind('pie-small'))
	movie.tween_callback(apply_boost)
	movie.tween_interval(3.0)
	
	# Cleanup
	await movie.finished
	movie.kill()

func apply_boost() -> void:
	var new_boost := STAT_BOOST_REFERENCE.duplicate(true)
	
	new_boost.quality = StatusEffect.EffectQuality.POSITIVE
	
	new_boost.stat = "damage"
	new_boost.boost = BOOST_AMT
	new_boost.rounds = -1
	new_boost.target = targets[0]
	
	manager.add_status_effect(new_boost)
