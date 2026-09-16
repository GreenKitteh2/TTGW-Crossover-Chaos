@tool
extends Node3D

@export var size: Vector2 = Vector2(1.0, 1.0):
	set(x):
		size = x
		if not is_node_ready():
			await ready
		mesh.mesh.size = size
		if want_center_offset:
			mesh.mesh.center_offset.y = size.y * 0.5
		else:
			mesh.mesh.center_offset = Vector3.ZERO
@export var want_center_offset := true

@onready var mesh: MeshInstance3D = %Mesh

func set_mat(mat: StandardMaterial3D) -> void:
	mesh.set_surface_override_material(0, mat)
