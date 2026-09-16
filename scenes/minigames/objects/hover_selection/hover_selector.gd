extends Control


func _process(_delta : float) -> void:
	if get_parent() is Node3D:
		visible = not get_viewport().get_camera_3d().is_position_behind(get_parent().global_transform.origin)
		position = get_viewport().get_camera_3d().unproject_position(get_parent().global_position)
