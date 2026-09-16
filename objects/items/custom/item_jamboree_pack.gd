extends ItemScript


func on_collect(_item: Item, _model: Node3D) -> void:
	setup()
 
func on_load(_item: Item) -> void:
	setup()

func setup() -> void:
	BattleService.s_battle_started.connect(on_battle_start)

func on_battle_start(manager: BattleManager) -> void:
	manager.s_action_added.connect(action_injected)
	manager.s_round_started.connect(round_started)

func round_started(gags: Array[BattleAction]) -> void:
	for gag in gags:
		if gag is GagSound:
			gag.do_knockback = true

func action_injected(action : BattleAction) -> void:
	if action is GagSound:
		action.do_knockback = true
