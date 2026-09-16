extends Node3D
class_name ActivatedPlatform

signal s_show_platform
signal s_hide_platform

@onready var semi_transparent_materials = [
	%platform.get_surface_override_material(0),
	%platform.get_surface_override_material(1),
	%platform.get_surface_override_material(2),
]
@onready var original_materials = [
	%platform.mesh.surface_get_material(0),
	%platform.mesh.surface_get_material(1),
	%platform.mesh.surface_get_material(2),
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_platform()

func _on_Switch_pressed(_button) -> void:
	show_platform()
	s_show_platform.emit()

func _on_Timer_timeout() -> void:
	hide_platform()
	s_hide_platform.emit()

func show_platform() -> void:
	%CollisionShape3D.call_deferred("set_disabled", false)
	for i in range(3):
		%platform.set_surface_override_material(i, original_materials[i])

func hide_platform() -> void:
	%CollisionShape3D.call_deferred("set_disabled", true)
	for i in range(3):
		%platform.set_surface_override_material(i, semi_transparent_materials[i])
