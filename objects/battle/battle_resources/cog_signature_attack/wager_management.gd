extends CogAttack
const COG := preload('res://objects/cog/cog.tscn')

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
	var cog: Cog = user
	apply_effect(cog)
	
	var tween := manager.create_tween()
	tween.tween_callback(battle_node.focus_character.bind(cog))
	tween.tween_callback(cog.set_animation.bind('effort'))
	tween.tween_interval(5.0)
	
	await tween.finished
	tween.kill()

func apply_effect(cog : Cog) -> void:
	var mod_effect: StatusEffect = RNG.channel(RNG.ChannelModCogEffects).pick_random(MOD_EFFECTS).duplicate(true)
	mod_effect.rounds = 3
	mod_effect.target = cog
	manager.add_status_effect(mod_effect)
