extends Control

const WAIT_TIME := 1.5
const FADE_TIME := 1.5

func _ready() -> void:
	do_fadeout()

func do_fadeout() -> void:
	var fade_tween := create_tween()
	fade_tween.tween_property(self, 'modulate:a', 1.0, FADE_TIME)
	fade_tween.tween_interval(WAIT_TIME)
	fade_tween.tween_property(self, 'modulate:a', 0.0, FADE_TIME)
	fade_tween.finished.connect(
		func():
			fade_tween.kill()
			queue_free()
	)

func set_text(text : String) -> void:
	$Label.set_text(text)
