@tool
extends StatusEffect

var mint_auditor: Cog:
	get: return target

const ACTION_BULL_MARKET := preload("res://objects/battle/battle_resources/misc_movies/auditor_boss/bull_market.tres")
const ACTION_BEAR_MARKET := preload("res://objects/battle/battle_resources/misc_movies/auditor_boss/bear_market.tres")
const ACTION_REINFORCEMENTS := preload("res://objects/battle/battle_resources/cog_attacks/resources/call_reinforcements.tres")

func apply() -> void:
	manager.s_round_started.connect(round_started)

func cleanup() -> void:
	if manager.s_round_started.is_connected(round_started):
		manager.s_round_started.disconnect(round_started)

var cogs := {}

# bear is 1 and bull is 2
var current_market := 0
func setup() -> void:
	BattleService.s_battle_started.connect(on_battle_start)
	
func on_battle_start() -> void:
	manager.current_round = 0
	
func round_started(_actions: Array[BattleAction]) -> void:
	var market = current_market
	# For reinforcements
	cogs.clear()
	for cog in manager.cogs:
		cogs[cog] = cog.stats.hp
		
	# Market switching XD
	if manager.current_round % 3 == 1:
		if market == 1:
			queue_bull_market()
			current_market = 0
		else:
			queue_bear_market()
			current_market = 1

	if manager.current_round % 2 == 1 and manager.cogs.size() < 2:
		queue_reinforcements()
		
func queue_reinforcements() -> void:
	var action := ACTION_REINFORCEMENTS.duplicate()
	action.user = mint_auditor
	manager.round_end_actions.append(action)

func queue_bull_market() -> void:
	var action := ACTION_BULL_MARKET.duplicate()
	action.user = mint_auditor
	manager.round_end_actions.append(action)

func queue_bear_market() -> void:
	var action := ACTION_BEAR_MARKET.duplicate()
	action.user = mint_auditor
	manager.round_end_actions.append(action)
