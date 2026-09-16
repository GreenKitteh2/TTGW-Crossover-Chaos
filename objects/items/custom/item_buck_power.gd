extends ItemScript

const BOOST_STATS := [
	["damage", Color("fc954cff")],
	["defense", Color("5c81edff")],
	["evasiveness", Color("e366d4ff")],
	["luck", Color("53db6cff")],
]

var boost_num := 0.00

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
		var choice: Array = BOOST_STATS.pick_random()
		boost_num = (randi_range(1, 10) * 0.01)
		Util.get_player().stats[choice[0]] += boost_num
		if BattleService.ongoing_battle:
			BattleService.ongoing_battle.battle_stats[Util.get_player()][choice[0]] += boost_num
