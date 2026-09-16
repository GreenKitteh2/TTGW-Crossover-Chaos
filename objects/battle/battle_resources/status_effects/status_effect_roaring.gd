@tool
extends StatusEffect


func apply() -> void:
	manager.battle_stats[target].defense *= 1.25
	manager.battle_stats[target].damage *= 1.25

func expire() -> void:
	manager.battle_stats[target].defense *= 1
	manager.battle_stats[target].damage *= 1
		
func get_status_name() -> String:
	return "Roaring"
