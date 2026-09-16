@tool
extends StatusEffect

const DAMAGE_BOOST_RATE := 0.05
const STAT_BOOST := "res://objects/battle/battle_resources/status_effects/resources/status_effect_overhire_cog.tres"
const STAT2_BOOST := "res://objects/battle/battle_resources/status_effects/resources/status_effect_overhire_cog2.tres"

var cog_effect: StatBoost
var cog_effect2: StatBoost

func apply() -> void:
	cog_effect = load(STAT_BOOST).duplicate(true)
	cog_effect.rounds = -1
	cog_effect.quality = StatusEffect.EffectQuality.POSITIVE
	cog_effect.target = target
	manager.s_participant_joined.connect(on_participants_changed)
	manager.s_participant_died.connect(on_participants_changed)
	refresh_effect(cog_effect)
	manager.add_status_effect(cog_effect)
	cog_effect2 = load(STAT2_BOOST).duplicate(true)
	cog_effect2.rounds = -1
	cog_effect2.quality = StatusEffect.EffectQuality.POSITIVE
	cog_effect2.target = target
	manager.s_participant_joined.connect(on_participants_changed)
	manager.s_participant_died.connect(on_participants_changed)
	refresh_effect(cog_effect2)
	manager.add_status_effect(cog_effect2)
	
func on_participants_changed(_p) -> void:
	if cog_effect:
		refresh_effect(cog_effect)
	if cog_effect2:
		refresh_effect(cog_effect2)

func refresh_effect(effect: StatBoost) -> void:
	effect.boost = (DAMAGE_BOOST_RATE * manager.cogs.size())
	

func cleanup() -> void:
	manager.expire_status_effect(cog_effect)
