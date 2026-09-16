@tool
extends StatusEffect

func apply() -> void:
	manager.battle_stats[Util.get_player()].gag_discount -= 1

func cleanup() -> void:
	manager.battle_stats[Util.get_player()].gag_discount += 1
