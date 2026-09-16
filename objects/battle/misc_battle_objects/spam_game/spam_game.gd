extends Control

const PROGRESS_PER_PRESS := 5.0
const LOSE_RATE := -5.0
const RATE_ACCELERATION := 0.2

@onready var progress_bar : ProgressBar = $Game/ProgressBar
@onready var button : GeneralButton = $Game/GeneralButton

var rate_multiplier := 1.0

signal s_button_pressed
signal s_game_finished(win : bool)


func button_pressed() -> void:
	progress_bar.value += PROGRESS_PER_PRESS
	if progress_bar.value >= progress_bar.max_value:
		s_game_finished.emit(true)

func _process(delta : float) -> void:
	progress_bar.value += (LOSE_RATE * rate_multiplier) * delta
	if progress_bar.value <= progress_bar.min_value:
		s_game_finished.emit(false)
	
	rate_multiplier += delta * RATE_ACCELERATION
