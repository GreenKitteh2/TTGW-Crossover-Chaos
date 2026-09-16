extends FloorModifier

const HEAL_AMOUNT := 1

## Decreases the Cog level min/max for the floor
func modify_floor() -> void:
	BattleService.s_battle_ended.connect(on_battle_finished)

func clean_up() -> void:
	BattleService.s_battle_ended.disconnect(on_battle_finished)

func on_battle_finished() -> void:
	if not is_instance_valid(Util.get_player()): return
	
	var player := Util.get_player()
	Util.get_player().quick_heal(get_heal_amount(player.stats.max_hp))

func get_heal_amount(max_hp: int) -> int:
	return ceili(max_hp * HEAL_AMOUNT)

func get_mod_name() -> String:
	return "Cheerful Triamph"

func get_mod_quality() -> ModType:
	return ModType.SUPERPOSITIVE

func get_mod_icon() -> Texture2D:
	return load("res://ui_assets/player_ui/pause/cheer.png")

func get_description() -> String:
	return "Receive a full heal after every battle"
