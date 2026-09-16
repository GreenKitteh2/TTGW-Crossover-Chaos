@tool
extends StatusEffect

var laff_count := 0

func apply():
	laff_count = RNG.channel(RNG.ChannelLaffBoosts).randi_range(2, 6)

func cleanup() -> void:
	Util.get_player().stats.max_hp = Util.get_player().stats.max_hp + laff_count
	Util.get_player().stats.hp = Util.get_player().stats.hp + laff_count

func get_description() -> String:
	return "Defeat this Cog to get %d extra laffs" % laff_count

func combine(effect : StatusEffect) -> bool:
	if 'laff_count' in effect:
		laff_count += effect.laff_count
		return true
	return false
