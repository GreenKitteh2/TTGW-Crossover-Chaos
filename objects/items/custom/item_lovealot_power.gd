extends ItemScript

func on_collect(_item: Item, _object: Node3D) -> void:
	setup()
	
func on_load(_item: Item) -> void:
	setup()

func setup() -> void:
	BattleService.s_battle_started.connect(battle_started)

func battle_started(battle: BattleManager) -> void:
	battle.s_participant_died.connect(participant_died)

func participant_died(participant: Node3D) -> void:
	if participant is Cog and participant.dna and participant.dna.is_crossover_cog:
		Util.get_player().stats.max_hp = Util.get_player().stats.max_hp + 1
		Util.get_player().stats.hp = Util.get_player().stats.hp + 1
