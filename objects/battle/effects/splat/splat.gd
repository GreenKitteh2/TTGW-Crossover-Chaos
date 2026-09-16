extends Sprite3D

func _ready():
	top_level = true
	scale = Vector3(0,0,0)
	var splat_tween := create_tween()
	splat_tween.tween_property(self,'scale',Vector3(2,2,2),0.5)
	await splat_tween.finished
	queue_free()

func set_text(text : String) -> void:
	$Label3D.text = text
