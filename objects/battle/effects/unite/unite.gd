extends GPUParticles3D


func _ready() -> void:
	await finished
	queue_free()
