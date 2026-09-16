extends RhythmPlatform

@export var sink_y := 0.0

@onready var rise_y := position.y

var sink_tween : Tween


func _ready() -> void:
	pass

func set_enabled(enable : bool) -> void:
	enabled = enable
	
	match enable:
		true:
			rise()
		false:
			sink()
	
	s_enabled_set.emit(enabled)

func sink() -> void:
	kill_tween()
	sink_tween = create_tween()
	sink_tween.tween_property(self, 'position:y', sink_y, 0.25)
	sink_tween.finished.connect(sink_tween.kill)

func rise() -> void:
	kill_tween()
	sink_tween = create_tween()
	sink_tween.tween_property(self, 'position:y', rise_y, 0.25)
	sink_tween.finished.connect(sink_tween.kill)

func kill_tween() -> void:
	if sink_tween:
		if sink_tween.is_running():
			sink_tween.kill()

func set_color(_color : Color) -> void:
	pass
