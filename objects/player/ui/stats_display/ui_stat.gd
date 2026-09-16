extends HBoxContainer

@export var stat : String


func _ready() -> void:
	set_stat(stat)

func set_stat(new_stat : String) -> void:
	stat = new_stat
	attempt_sync()
	connect_stat()

func attempt_sync() -> void:
	if not is_instance_valid(Util.get_player()): return
	elif not Util.get_player().stats: return
	
	$Label.set_text("%s: %.2f" % [stat.to_upper(), Util.get_player().stats.get_stat(stat)])

func get_stat_signal() -> Variant:
	if not is_instance_valid(Util.get_player()): return
	elif not Util.get_player().stats: return
	var stats : PlayerStats = Util.get_player().stats
	if stats.has_signal('s_' + stat + '_changed'):
		return stats.get('s_' + stat + '_changed')
	return

func connect_stat() -> void:
	var connected_signal = get_stat_signal()
	if connected_signal is Signal:
		connected_signal.connect(stat_changed)

func stat_changed(_new_stat : Variant) -> void:
	attempt_sync()
