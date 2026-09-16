@tool
extends StatusEffect

func apply() -> void:
	Util.get_player().use_accuracy = true
	target.stats.accuracy = 0.5

func expire() -> void:
	Util.get_player().use_accuracy = false
	target.stats.accuracy = 1

func cleanup() -> void:
	expire()

func combine(effect : StatusEffect) -> bool:
	if effect.rounds > rounds:
		rounds = effect.rounds
	return true
