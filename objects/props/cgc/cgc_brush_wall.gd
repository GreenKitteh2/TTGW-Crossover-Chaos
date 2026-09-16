@tool
extends Node3D


@export var length: float = 1.0:
	set(x):
		length = x
		if not is_node_ready():
			await ready
		mesh.mesh.size.x = length

@onready var mesh: MeshInstance3D = %Mesh
