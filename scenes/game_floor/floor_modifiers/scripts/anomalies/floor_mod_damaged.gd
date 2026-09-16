extends FloorModifier

## Gives all cogs on the floor
func modify_floor() -> void:
	BattleService.s_battle_started.connect(on_battle_start)

func on_battle_start(battle : BattleManager) -> void:
	for cog in battle.cogs:
		cog.stats.hp = (cog.stats.hp - (cog.stats.max_hp * 0.25))
	battle.s_participant_joined.connect(func(participant):
		if participant is Cog:
			participant.stats.hp = (participant.stats.hp - (participant.stats.max_hp * 0.25))
	)
	#battle.s_status_effect_added.connect(on_status_effect_added)
	
	await Util.s_process_frame
	
	BattleService.s_refresh_statuses.emit()
	BattleService.ongoing_battle.battle_ui.cog_panels.reset(0)
	BattleService.ongoing_battle.battle_ui.cog_panels.assign_cogs(BattleService.ongoing_battle.cogs)

func get_mod_quality() -> ModType:
	return ModType.POSITIVE

func get_mod_name() -> String:
	return "Damaged Function"

func get_mod_icon() -> Texture2D:
	return load("res://ui_assets/player_ui/pause/damaged.png")

func get_description() -> String:
	return "Cogs lose 25% HP"
