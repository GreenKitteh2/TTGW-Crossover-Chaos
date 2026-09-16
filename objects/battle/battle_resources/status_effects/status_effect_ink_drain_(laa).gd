@tool
extends StatusEffect

const STAT_DIFF_NEG := -0.25
const STAT_DIFF_RESTORE := 0.25

func apply() -> void:
	var stats : PlayerStats = target.stats
	for track in stats.gag_effectiveness:
		stats.gag_effectiveness.Drop += STAT_DIFF_NEG
		stats.gag_effectiveness.Lure += STAT_DIFF_NEG
		stats.gag_effectiveness.Sound += STAT_DIFF_NEG
		stats.gag_effectiveness.Squirt += STAT_DIFF_NEG
		stats.gag_effectiveness.Throw += STAT_DIFF_NEG
		stats.gag_effectiveness.Trap += STAT_DIFF_NEG

func cleanup() -> void:
	if not target:
		return
	var stats : PlayerStats = target.stats
	for track in stats.gag_effectiveness:
		stats.gag_effectiveness.Drop += STAT_DIFF_RESTORE
		stats.gag_effectiveness.Lure += STAT_DIFF_RESTORE
		stats.gag_effectiveness.Sound += STAT_DIFF_RESTORE
		stats.gag_effectiveness.Squirt += STAT_DIFF_RESTORE
		stats.gag_effectiveness.Throw += STAT_DIFF_RESTORE
		stats.gag_effectiveness.Trap += STAT_DIFF_RESTORE
	manager.s_battle_ending.disconnect(cleanup)

func combine(effect : StatusEffect) -> bool:
	if effect.rounds > rounds:
		rounds = effect.rounds
	return true
