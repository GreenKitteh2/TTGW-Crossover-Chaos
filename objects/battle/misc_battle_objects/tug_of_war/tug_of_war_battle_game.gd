extends Control

@export var win_quota := 5.0

@onready var game := $TugOfWarGame

var win_progress := 0.0

signal s_win


func _process(delta : float) -> void:
	if game.is_winning():
		win_progress += delta
	
	if win_progress >= win_quota:
		s_win.emit()
		queue_free()
