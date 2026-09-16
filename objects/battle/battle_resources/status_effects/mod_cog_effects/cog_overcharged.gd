@tool
extends StatusEffect


func apply() -> void:
	var cog: Cog = target
	
	#cog.stats.damage *= 1.1
	manager.s_action_started.connect(on_action_start)
	if cog.stats.hp >= cog.stats.max_hp * 1.5:
		self.visible = true
		manager.s_status_effect_added.connect(on_status_effect_added)
	else: 
		self.visible = false
		expire()

func on_action_start(action : BattleAction) -> void:
	if action.user == target:
		self.visible = true
		if target.stats.hp >= target.stats.max_hp * 1.5:
			action.damage = action.damage * 1.5
		else:
				self.visible = false

func on_status_effect_added(effect: StatusEffect) -> void:
	if not is_instance_valid(target):
		return
	
	var cog: Cog = target
	if not cog == effect.target or not effect is StatusLured:
		return
	
	effect.rounds = 0

func cleanup() -> void:
	manager.s_action_started.disconnect(on_action_start)

func get_status_name() -> String:
	return "Overcharged"

func get_icon() -> Texture2D:
	return load("res://ui_assets/battle/statuses/overcharged.png")
	
func renew() -> void:
		if target.stats.hp >= target.stats.max_hp * 1.5:
			self.visible = true
		else:
			self.visible = false
