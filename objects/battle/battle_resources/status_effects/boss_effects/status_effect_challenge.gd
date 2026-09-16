@tool
extends StatusEffect

func apply() -> void:
	target.stats.turns += 1
	target.stats.damage = 1.5

func expire() -> void:
	target.stats.turns -= 1
	target.stats.damage = 1

func combine(effect : StatusEffect) -> bool:
	if effect.rounds > rounds:
		rounds = effect.rounds
	return true
