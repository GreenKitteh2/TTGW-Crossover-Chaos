extends CogAttack
const COG := preload('res://objects/cog/cog.tscn')

const STATUS_EFFECT := preload('res://objects/battle/battle_resources/status_effects/resources/status_effect_auto_repair.tres')

const PHRASES := [
	"This might hurt a bit.",
	"I have this speical gimmick to test out.",
	"I might need you as my subject."
]

var response_lines: Array[String] = [
	"What did you put?",
	"Ow.",
	"Is this allowed?"
]

static var MOD_EFFECTS: Array[StatusEffect] = [
	preload("res://objects/battle/battle_resources/status_effects/resources/mod_cog_investment.tres"),
	preload("res://objects/battle/battle_resources/status_effects/resources/mod_cog_pinpoint.tres"),
	preload("res://objects/battle/battle_resources/status_effects/resources/mod_cog_insured.tres"),
	preload("res://objects/battle/battle_resources/status_effects/resources/mod_cog_diverse_portfolio.tres"),
	preload("res://objects/battle/battle_resources/status_effects/resources/mod_cog_banker.tres"),
	preload("res://objects/battle/battle_resources/status_effects/resources/mod_cog_embezzler.tres"),
	preload("res://objects/battle/battle_resources/status_effects/resources/mod_cog_tax_collector.tres"),
	preload("res://objects/battle/battle_resources/status_effects/resources/mod_cog_fire_sale.tres"),
	preload("res://objects/battle/battle_resources/status_effects/resources/mod_cog_agile.tres"),
	preload("res://objects/battle/battle_resources/status_effects/resources/mod_cog_leverage.tres"),
	preload("res://objects/battle/battle_resources/status_effects/resources/mod_cog_interference.tres"),
	preload("res://objects/battle/battle_resources/status_effects/resources/mod_cog_wheelhouse.tres"),
	preload("res://objects/battle/battle_resources/status_effects/resources/mod_cog_asset_protection.tres"),
	preload("res://objects/battle/battle_resources/status_effects/resources/mod_cog_sturdy.tres"),
	preload("res://objects/battle/battle_resources/status_effects/resources/mod_cog_witness_protection.tres"),
	preload("res://objects/battle/battle_resources/status_effects/resources/mod_cog_backtalker.tres"),
	preload("res://objects/battle/battle_resources/status_effects/resources/mod_cog_toxic.tres"),
]

func action() -> void:
	if len(manager.cogs) <= 1:
		return
	var cog: Cog = user
	var target : Cog = targets[0]
	
	var movie := manager.create_tween()
	
	# Focus user
	manager.show_action_name("Injection!", "Grants a Cog a temporary Proxy effect")
	var phrase_choice: String = RandomService.array_pick_random('true_random', PHRASES)
	movie.tween_callback(cog.speak.bind(phrase_choice))
	movie.tween_callback(battle_node.focus_character.bind(cog))
	movie.tween_callback(cog.set_animation.bind('effort'))
	movie.tween_callback(cog.face_position.bind(target.global_position))
	movie.tween_interval(3.0)
	
	# Focus target
	movie.tween_callback(target.set_animation.bind('pie-small'))
	var dialogue_choice: String = RandomService.array_pick_random('true_random', response_lines)
	movie.tween_callback(target.speak.bind(dialogue_choice))
	movie.tween_callback(apply_effect)
	movie.tween_callback(battle_node.focus_character.bind(target))
	movie.tween_interval(3.0)
	
	# Cleanup
	await movie.finished
	movie.kill()

func apply_effect() -> void:
	var mod_effect: StatusEffect = RNG.channel(RNG.ChannelModCogEffects).pick_random(MOD_EFFECTS).duplicate(true)
	mod_effect.rounds = 3
	mod_effect.target = targets[0]
	manager.add_status_effect(mod_effect)
