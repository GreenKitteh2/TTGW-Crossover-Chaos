@tool
extends StatusEffect

func apply() -> void:
	Util.get_player().stats.battle_timers.append(20)


func expire() -> void:
	Util.get_player().stats.battle_timers.erase(20)

func cleanup() -> void:
	Util.get_player().stats.battle_timers.erase(20)

func combine(effect : StatusEffect) -> bool:
	if effect.rounds > rounds:
		rounds = effect.rounds
	return true
