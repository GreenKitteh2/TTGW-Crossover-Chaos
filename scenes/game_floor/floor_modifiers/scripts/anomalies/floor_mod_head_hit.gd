extends FloorModifier

const STATUS_EFFECT := preload('res://objects/battle/battle_resources/status_effects/resources/status_effect_staggered.tres')

func modify_floor() -> void:
	BattleService.s_battle_started.connect(on_battle_start)

func on_battle_start(battle : BattleManager) -> void:
	for cog in battle.cogs:
		apply_random_effect(cog) # Apply random status immediately
	battle.s_participant_joined.connect(func(participant):
		if participant is Cog:
			apply_random_effect(participant) # New cog joining mid-battle also gets effect
	)
	#battle.s_status_effect_added.connect(on_status_effect_added)
	
	await Util.s_process_frame
	
	BattleService.s_refresh_statuses.emit()
	BattleService.ongoing_battle.battle_ui.cog_panels.reset(0)
	BattleService.ongoing_battle.battle_ui.cog_panels.assign_cogs(BattleService.ongoing_battle.cogs)

func apply_random_effect(cog : Cog) -> void:
	var effect := STATUS_EFFECT.duplicate()
	effect.target = cog
	effect.rounds = -1
	BattleService.ongoing_battle.add_status_effect(effect)

func get_mod_name() -> String:
	return "Headbonk"

func get_mod_icon() -> Texture2D:
	return load("res://ui_assets/player_ui/pause/head_hit.png")

func get_description() -> String:
	return "Cogs have a chance to not attack"

func get_mod_quality() -> ModType:
	return ModType.POSITIVE
