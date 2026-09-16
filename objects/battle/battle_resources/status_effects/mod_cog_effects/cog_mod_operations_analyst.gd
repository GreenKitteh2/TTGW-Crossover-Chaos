@tool
extends StatusEffect


func apply() -> void:
	manager.battle_stats[target].defense *= 1.5
	manager.battle_stats[target].damage *= 0.5

func get_status_name() -> String:
	return "Operations Analyst"
