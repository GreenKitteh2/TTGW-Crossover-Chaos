extends ItemScript

const DMG_BONUS := 0.1

var dmg_sum := 0.0

func on_collect(_item: Item, _model: Node3D) -> void:
	setup()

func on_load(_item: Item) -> void:
	setup()

func setup() -> void:
	BattleService.s_action_started.connect(on_action_started)
	BattleService.s_action_finished.connect(on_action_finished)
	BattleService.s_round_ended.connect(on_round_ended)

func on_action_started(action: BattleAction) -> void:
	if action is ToonAttack and not is_equal_approx(dmg_sum, 0.0):
		action.store_boost_text("Sequel Boost!", Color(0.466, 0.663, 0.935))

func on_round_ended(manager: BattleManager) -> void:
	manager.battle_stats[Util.get_player()].damage -= dmg_sum
	dmg_sum = 0.0
	print_damage()

func on_action_finished(action: BattleAction) -> void:
	if action is ToonAttack:
		BattleService.ongoing_battle.battle_stats[Util.get_player()].damage += DMG_BONUS
		dmg_sum += DMG_BONUS
		print_damage()

func print_damage() -> void:
	print('Celebrity: New damage value: %s' % BattleService.ongoing_battle.battle_stats[Util.get_player()].damage)
