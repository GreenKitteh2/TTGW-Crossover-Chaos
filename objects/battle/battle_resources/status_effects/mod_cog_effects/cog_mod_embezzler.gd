@tool
extends StatusEffect

const HEAL_MODIFIER := 6

var player_hp := 0

func apply() -> void:
	Util.get_player().stats.hp_changed.connect(player_hp_change)
	player_hp = Util.get_player().stats.hp

func cleanup() -> void:
	if Util.get_player() and Util.get_player().stats.hp_changed.is_connected(player_hp_change):
		Util.get_player().stats.hp_changed.disconnect(player_hp_change)

func player_hp_change(hp: int) -> void:
	if hp < player_hp and manager.current_action and manager.current_action.user == target:
		target.stats.hp += (player_hp - hp) * HEAL_MODIFIER
	player_hp = hp
