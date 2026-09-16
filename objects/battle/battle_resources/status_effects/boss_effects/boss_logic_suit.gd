@tool
extends StatusEffect

var witness_stand_in: Cog:
	get: return target

const ACTION_BACKUP := preload("res://objects/battle/battle_resources/cog_attacks/resources/backup.tres")

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
		queue_backup()
		
func queue_backup() -> void:
	var action := ACTION_BACKUP.duplicate()
	action.user = witness_stand_in
	manager.round_end_actions.append(action)
