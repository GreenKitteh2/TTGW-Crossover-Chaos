extends CogAttack
const COG := preload('res://objects/cog/cog.tscn')
var SFX := preload("res://audio/sfx/battle/cogs/attacks/special/SA_extra_tip.ogg")

const PHRASES := [
	"Do I gotta provide the muscle for ya?!",
	"Consider this ya share for this operation.",
	"I said I wouldn't let anyone mess with ya, didn't I?!",
	"C'mon ya neutron stars, keep yourselves together!"
]

const STAT_BOOST_REFERENCE := preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_stat_boost.tres")
const BOOST_RANGE := Vector2(0.4, 0.6)

func action() -> void:
	var cog: Cog = user
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
	manager.show_action_name("Slush Fund!", "Grants all Cogs defense boosts")
	var phrase_choice: String = RandomService.array_pick_random('true_random', PHRASES)
	movie.tween_callback(cog_user.speak.bind(phrase_choice))
	movie.tween_callback(battle_node.focus_character.bind(cog))
	movie.parallel().tween_callback(AudioManager.play_sound.bind(SFX))
	movie.tween_callback(cog_user.set_animation.bind('effort'))
	movie.tween_interval(3.0)
	
	# Focus target
	for target in targets:
		movie.tween_callback(create_status_effects.bind(target))
	movie.tween_callback(create_status_effects.bind(cog_user))
	movie.tween_interval(3.0)
	
	# Cleanup
	await movie.finished
	movie.kill()

func create_status_effects(target: Cog) -> void:
	var stat_boost := STAT_BOOST_REFERENCE.duplicate()
	stat_boost.quality = StatusEffect.EffectQuality.POSITIVE
	
	stat_boost.stat = "defense"
	stat_boost.boost = 0.25
	stat_boost.target = target
	stat_boost.rounds = 3
	manager.add_status_effect(stat_boost)
