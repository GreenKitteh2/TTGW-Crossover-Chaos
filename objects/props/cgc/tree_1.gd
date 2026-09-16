extends MeshInstance3D

@onready var sb3d: StaticBody3D = %StaticBody3D
@onready var cs3d: CollisionShape3D = %CollisionShape3D


func _ready() -> void:
	set_notify_transform(true)
	# Required because the collision is top-level
	sb3d.global_position = global_position

func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSFORM_CHANGED:
		sb3d.global_position = global_position
