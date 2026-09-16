extends ItemScript

const DAMAGE_BOOST := 1.1

func on_collect(_item: Item, _model: Node3D) -> void:
	setup()

func on_load(_item: Item) -> void:
	setup()

func setup() -> void:
	BattleService.s_round_started.connect(round_started)

func round_started(actions : Array[BattleAction]) -> void:
	if BattleService.ongoing_battle.current_round == 1:
		for action in actions:
			if action is ToonAttack:
				action.damage *= DAMAGE_BOOST
				action.store_boost_text("First Strike!", Color(1, 0.431, 0))
