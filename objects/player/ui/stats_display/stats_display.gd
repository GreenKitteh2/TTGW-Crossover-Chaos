extends VBoxContainer

const STATS_TO_TRACK := ['damage', 'defense', 'accuracy', 'evasiveness']
const UI_STAT := preload('res://objects/player/ui/stats_display/ui_stat.tscn')


func _ready() -> void:
	var player : Player = get_parent()
	await player.ready
	for stat in STATS_TO_TRACK:
		var new_stat := UI_STAT.instantiate()
		add_child(new_stat)
		new_stat.set_stat(stat)
	player.s_stats_connected.connect(reconnect_stats)

func reconnect_stats() -> void:
	var player : Player = get_parent()
	for child in get_children():
		child.set_stat(child.stat)
