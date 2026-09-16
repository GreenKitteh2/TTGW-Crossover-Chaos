extends Node3D

var manager: BattleManager = null

func _ready() -> void:
	await Task.delay(0.25)
	manager = await BattleService.s_battle_started

func get_camera_angle(angle : String) -> Transform3D:
	return $CameraAngles.find_child(angle).global_transform
	
func get_char_position(pos : String) -> Vector3:
	return $CharPositions.find_child(pos).global_position
