@tool
extends StatusEffect

var witness_stand_in: Cog:
	get: return target

const ACTION_RESURRECT := preload("res://objects/battle/battle_resources/misc_movies/witness_boss/wsi_resurrect.tres")
const ACTION_CHALLENGE := preload("res://objects/battle/battle_resources/misc_movies/witness_boss/challenge.tres")
const ACTION_QUASH := preload("res://objects/battle/battle_resources/misc_movies/witness_boss/quash.tres")
const ACTION_IMMUNITY := preload("res://objects/battle/battle_resources/misc_movies/witness_boss/wsi_extra_immunity.tres")

func apply() -> void:
	manager.s_round_started.connect(round_started)

func cleanup() -> void:
	if manager.s_round_started.is_connected(round_started):
		manager.s_round_started.disconnect(round_started)

var cogs := {}

func round_started(_actions: Array[BattleAction]) -> void:
	
	# For compensation
	cogs.clear()
	for cog in manager.cogs:
		cogs[cog] = cog.stats.hp
	
	if manager.current_round % 2 == 1 and manager.cogs.size() < 2:
		queue_resurrect()
		
	# For overtime
	if manager.current_round % 3 == 2:
		queue_challenge()
	
	if manager.current_round % 3 == 1:
		queue_quash()
		
	if manager.current_round % 4 == 3:
		queue_extraimmunity()
		
func queue_resurrect() -> void:
	var action := ACTION_RESURRECT.duplicate()
	action.user = witness_stand_in
	manager.round_end_actions.append(action)


func queue_challenge() -> void:
	# Try to find a non boss cog
	var potential_cogs : Array[Cog] = []
	for cog in manager.cogs:
		if not cog.dna.custom_nametag_suffix == "Deceased":
			potential_cogs.append(cog)
	if potential_cogs.is_empty():
		return
	
	# Create the action
	var action := ACTION_CHALLENGE.duplicate()
	action.user = target
	action.targets = [RandomService.array_pick_random('true_random', potential_cogs)]
	manager.round_end_actions.append(action)
	
func queue_quash() -> void:
	var potential_cogs : Array[Cog] = []
	for cog in manager.cogs:
		if not cog.dna.custom_nametag_suffix == "Deceased":
			potential_cogs.append(cog)
	if potential_cogs.is_empty():
		return
		
	var quash_action := ACTION_QUASH.duplicate()
	quash_action.user = witness_stand_in
	quash_action.targets = potential_cogs
	manager.round_end_actions.append(quash_action)

func queue_extraimmunity() -> void:
	# Try to find a non boss cog
	var potential_cogs : Array[Cog] = []
	for cog in manager.cogs:
		if not cog.dna.custom_nametag_suffix == "Deceased":
			potential_cogs.append(cog)
	if potential_cogs.is_empty():
		return
	
	# Create the action
	var immunity_action := ACTION_IMMUNITY.duplicate()
	immunity_action.user = target
	immunity_action.targets = [RandomService.array_pick_random('true_random', potential_cogs)]
	manager.round_end_actions.append(immunity_action)
