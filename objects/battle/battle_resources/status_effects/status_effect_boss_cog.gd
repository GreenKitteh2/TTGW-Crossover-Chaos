@tool
extends StatusEffect

const POWER_EFFECT := preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_powered.tres")

const ACTION_REINFORCEMENTS := preload("res://objects/battle/battle_resources/cog_attacks/resources/call_reinforcements_boss_cog.tres")

func apply() -> void:
	manager.s_status_effect_added.connect(on_status_effect_added)
	manager.s_round_started.connect(round_started)

func cleanup() -> void:
	apply_power()
	Util.get_player().stats.hp = Util.get_player().stats.max_hp
	if manager.s_status_effect_added.is_connected(on_status_effect_added):
		manager.s_status_effect_added.disconnect(on_status_effect_added)
	if manager.s_round_started.is_connected(round_started):
		manager.s_round_started.disconnect(round_started)

var cogs := {}


func round_started(_actions: Array[BattleAction]) -> void:
	
	# For reinforcements
	cogs.clear()
	for cog in manager.cogs:
		cogs[cog] = cog.stats.hp
	
	if manager.current_round % 2 == 1 and manager.cogs.size() < 2:
		queue_reinforcements()

func queue_reinforcements() -> void:
	var cog: Cog = target
	var action := ACTION_REINFORCEMENTS.duplicate()
	action.user = cog
	manager.round_end_actions.append(action)

## Set all Lured effects on this Cog to expire the same round
func on_status_effect_added(effect: StatusEffect) -> void:
	if not is_instance_valid(target):
		return
	
	var cog: Cog = target
	if not cog == effect.target or not effect is StatusLured:
		return
	
	effect.rounds = 0

func get_status_name() -> String:
	return "Boss Cog"

func apply_power() -> void:
	var effect := POWER_EFFECT.duplicate(true)
	effect.target = Util.get_player()
	effect.rounds = -1
	manager.add_status_effect(effect)
