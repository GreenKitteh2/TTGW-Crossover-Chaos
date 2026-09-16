extends ItemScript

const AFFECTED_STATS := ['damage', 'defense', 'evasiveness', 'luck']

func on_collect(_item: Item, _object: Node3D) -> void:
	var total_stats: float = 0.0
	for stat_name: String in AFFECTED_STATS:
		total_stats += Util.get_player().stats.get(stat_name)
	for stat_name: String in AFFECTED_STATS:
		Util.get_player().stats.set(stat_name, total_stats / float(AFFECTED_STATS.size()))
	print('Balancing Scale: Setting %s to %s' % [AFFECTED_STATS, total_stats / float(AFFECTED_STATS.size())])
