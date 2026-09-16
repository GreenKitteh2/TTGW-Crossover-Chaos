@tool
extends StatusEffect

const BOOST_STATS := [
	["damage", Color("fc954cff")],
	["defense", Color("5c81edff")],
	["evasiveness", Color("e366d4ff")],
	["luck", Color("53db6cff")],
]

var laff_count := 0
var player: Player

func apply():
	laff_count = RNG.channel(RNG.ChannelLaffBoosts).randi_range(5, 10)

func cleanup() -> void:
	Util.get_player().stats.max_hp = Util.get_player().stats.max_hp + laff_count
	Util.get_player().stats.hp = Util.get_player().stats.hp + laff_count
	var choice: Array = BOOST_STATS.pick_random()
	Util.get_player().stats[choice[0]] += 0.10
	if BattleService.ongoing_battle:
		BattleService.ongoing_battle.battle_stats[Util.get_player()][choice[0]] += 0.10
	Util.get_player().boost_queue.queue_text("%s Up!" % choice[0].capitalize(), choice[1])	

func get_description() -> String:
	return "Defeat this Cog to get %d extra laffs and a random stat boost" % laff_count

func combine(effect : StatusEffect) -> bool:
	if 'laff_count' in effect:
		laff_count += effect.laff_count
		return true
	return false
