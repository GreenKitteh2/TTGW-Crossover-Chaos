extends ItemScript

const SOUND_EFFECT := preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_resonance.tres")
const EFFECT_RATIO := 0.5

func setup() -> void:
	BattleService.s_round_started.connect(on_round_started)

func on_round_started(actions : Array[BattleAction]) -> void:
	for action in actions:
		if action is GagSound:
			action.s_hit.connect(sound_hit.bind(action))

func sound_hit(action : GagSound) -> void:
	var gag_damage := BattleService.ongoing_battle.get_damage(action.damage, action, action.targets[0])
	var cog: Cog = action.targets[0]
	if cog.stats.hp > 0:
		apply_noise_effect(cog, get_damage(gag_damage))

func apply_noise_effect(cog : Cog, damage : int) -> void:
	var noise_effect := SOUND_EFFECT.duplicate(true)
	noise_effect.target = cog
	noise_effect.amount = damage
	noise_effect.rounds = 3
	noise_effect.icon = load("res://ui_assets/battle/statuses/resonance.png")
	BattleService.ongoing_battle.add_status_effect(noise_effect)

func get_damage(gag_damage : int) -> int:
	return ceili(gag_damage * EFFECT_RATIO)

func on_collect(_item : Item, _model : Node3D) -> void:
	setup()

func on_load(_item : Item) -> void:
	setup()
