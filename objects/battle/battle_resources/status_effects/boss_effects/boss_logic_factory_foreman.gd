@tool
extends StatusEffect

var factory_foreman: Cog:
	get: return target

const ACTION_FIELD_PROMOTION := preload("res://objects/battle/battle_resources/misc_movies/foreman_boss/field_promotion.tres")
const ACTION_REINFORCEMENTS := preload("res://objects/battle/battle_resources/cog_attacks/resources/call_reinforcements.tres")

func apply() -> void:
	manager.s_round_started.connect(round_started)

func cleanup() -> void:
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
		
	# For driving range
	if manager.current_round % 2 == 1:
		queue_field_promotion()
		
func queue_reinforcements() -> void:
	var action := ACTION_REINFORCEMENTS.duplicate()
	action.user = factory_foreman
	manager.round_end_actions.append(action)


func queue_field_promotion() -> void:
	# Try to find a non boss cog
	var potential_cogs : Array[Cog] = []
	for cog in manager.cogs:
		if not cog.dna.custom_nametag_suffix == "Supervisor":
			potential_cogs.append(cog)
	if potential_cogs.is_empty():
		return
	
	# Create the action
	var action := ACTION_FIELD_PROMOTION.duplicate()
	action.user = target
	action.targets = [RandomService.array_pick_random('true_random', potential_cogs)]
	manager.round_end_actions.append(action)
