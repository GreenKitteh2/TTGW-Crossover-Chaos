@tool
extends StatusEffect


func apply() -> void:
	target.stats.turns += 1
