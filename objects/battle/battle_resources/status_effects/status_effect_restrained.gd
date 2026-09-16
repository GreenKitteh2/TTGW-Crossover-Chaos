@tool
extends StatusEffect


func apply() -> void:
	manager.battle_stats[Util.get_player()].turns -= 1

func cleanup() -> void:
	manager.battle_stats[Util.get_player()].turns -= 0

func combine(effect : StatusEffect) -> bool:
	if effect.rounds > rounds:
		rounds = effect.rounds
	return true
