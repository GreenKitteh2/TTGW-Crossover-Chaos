extends CogAttack
const COG := preload('res://objects/cog/cog.tscn')

const PHRASES := [
	"Suits, commence vexatious litigation on the vermin!",
	"I command you to channel your choler towards these cumberworlds!",
	"Stop languishing and assail these animals!",
	"Suits, sally forth. We will cease this silliness!"
]

static var MOD_EFFECTS: Array[StatusEffect] = [
	preload("res://objects/battle/battle_resources/status_effects/resources/mod_cog_pinpoint.tres"),
	preload("res://objects/battle/battle_resources/status_effects/resources/mod_cog_insured.tres"),
	preload("res://objects/battle/battle_resources/status_effects/resources/mod_cog_diverse_portfolio.tres"),
	preload("res://objects/battle/battle_resources/status_effects/resources/mod_cog_banker.tres"),
	preload("res://objects/battle/battle_resources/status_effects/resources/mod_cog_embezzler.tres"),
	preload("res://objects/battle/battle_resources/status_effects/resources/mod_cog_agile.tres"),
	preload("res://objects/battle/battle_resources/status_effects/resources/mod_cog_leverage.tres"),
	preload("res://objects/battle/battle_resources/status_effects/resources/mod_cog_backtalker.tres"),
	preload("res://objects/battle/battle_resources/status_effects/resources/mod_cog_toxic.tres"),
]

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
	manager.show_action_name("Mob Mentality!", "Other Cogs gain attack power!")
	var phrase_choice: String = RandomService.array_pick_random('true_random', PHRASES)
	movie.tween_callback(cog_user.speak.bind(phrase_choice))
	battle_node.focus_cogs()
	battle_node.battle_cam.position.z += 3.0
	movie.tween_callback(cog_user.set_animation.bind('speak'))
	movie.tween_interval(3.0)
	
	# Focus target
	for target in targets:
		movie.tween_callback(create_status_effects.bind(target))
	movie.tween_interval(3.0)
	
	# Cleanup
	await movie.finished
	movie.kill()

func create_status_effects(target: Cog) -> void:
	var mod_effect: StatusEffect = RNG.channel(RNG.ChannelModCogEffects).pick_random(MOD_EFFECTS).duplicate(true)
	mod_effect.rounds = 3
	mod_effect.target = target
	manager.add_status_effect(mod_effect)
