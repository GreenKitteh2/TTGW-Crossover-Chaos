extends AnimatedSprite3D

const SFX_POOF := preload('res://audio/sfx/misc/firework_distance_02.ogg')


func _ready() -> void:
	AudioManager.play_sound(SFX_POOF)

func _on_animation_finished() -> void:
	queue_free()
