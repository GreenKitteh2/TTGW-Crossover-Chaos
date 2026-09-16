@tool
extends StatusEffect

const DAMAGE_BOOST_RATE := 0.05
const STAT_BOOST := "res://objects/battle/battle_resources/status_effects/resources/status_effect_forward_thinking_cog.tres"

var cog_effect: StatBoost

func apply() -> void:
	cog_effect = load(STAT_BOOST).duplicate(true)
	cog_effect.rounds = -1
	cog_effect.quality = StatusEffect.EffectQuality.POSITIVE
	cog_effect.target = target
	manager.s_participant_joined.connect(on_participants_changed)
	manager.s_participant_died.connect(on_participants_changed)
	refresh_effect(cog_effect)
	manager.add_status_effect(cog_effect)
	manager.s_round_started.connect(on_round_start)

func on_participants_changed(_p) -> void:
	if cog_effect:
		refresh_effect(cog_effect)

func on_round_start(actions: Array[BattleAction]) -> void:
	var inject_pos := 0
	for i in actions.size():
		if actions[i] is ToonAttack or actions[i] is CogAttack:
			inject_pos = i
			break

	for action in actions:
		if action.user == target:
			manager.round_actions.erase(action)
			manager.round_actions.insert(inject_pos, action)
			action.action_tags.append(BattleAction.ActionTag.PRIORITY_ACTION)

func refresh_effect(effect: StatBoost) -> void:
	effect.boost = (DAMAGE_BOOST_RATE * manager.cogs.size())

func cleanup() -> void:
	manager.s_round_started.disconnect(on_round_start)
	manager.expire_status_effect(cog_effect)
