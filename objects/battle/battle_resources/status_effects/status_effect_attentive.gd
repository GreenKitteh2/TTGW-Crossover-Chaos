@tool
extends StatusEffect
class_name StatEffectAttentive


func apply() -> void:
	manager.s_status_effect_added.connect(on_status_effect_added)

func cleanup() -> void:
	if manager.s_status_effect_added.is_connected(on_status_effect_added):
		manager.s_status_effect_added.disconnect(on_status_effect_added)

## Set all Lured effects on this Cog to expire the same round
func on_status_effect_added(effect: StatusEffect) -> void:
	if not is_instance_valid(target):
		return
	
	var cog: Cog = target
	if not cog == effect.target or not effect is StatusLured:
		return
	
	effect.rounds = 0

func get_status_name() -> String:
	return "Attentive"
