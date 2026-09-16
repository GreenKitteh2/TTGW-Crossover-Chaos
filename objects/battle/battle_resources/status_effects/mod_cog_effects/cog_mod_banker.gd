@tool
extends StatusEffect

func renew() -> void:
	target.stats.damage += 0.08
