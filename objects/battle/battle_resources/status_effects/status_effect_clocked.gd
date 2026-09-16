@tool
extends StatusEffect

func apply() -> void:
	Util.get_player().stats.battle_timers.append(10)


func expire() -> void:
	Util.get_player().stats.battle_timers.erase(10)

func cleanup() -> void:
	Util.get_player().stats.battle_timers.erase(10)

func combine(effect : StatusEffect) -> bool:
	if effect.rounds > rounds:
		rounds = effect.rounds
	return true
