@tool
extends StatusEffect

@export var stat: String = 'evasiveness'
@export var stat2: String = 'damage'
@export var boost: float = 0.10

func apply() -> void:
	var battle_stats: BattleStats = manager.battle_stats[target]
	if stat in battle_stats:
		battle_stats.set(stat,battle_stats.get(stat) - boost)
		battle_stats.set(stat2,battle_stats.get(stat2) - boost)

func cleanup() -> void:
	var battle_stats: BattleStats = manager.battle_stats[target]
	if stat in battle_stats:
		battle_stats.set(stat,battle_stats.get(stat) + boost)
		battle_stats.set(stat2,battle_stats.get(stat2) + boost)

func combine(effect : StatusEffect) -> bool:
	if effect.rounds > rounds:
		rounds = effect.rounds
	return true
