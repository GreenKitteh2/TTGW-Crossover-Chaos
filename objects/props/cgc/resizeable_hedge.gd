@tool
extends Node3D

@export var length: float = 1.0:
	set(x):
		length = x
		if not is_node_ready():
			await ready
		mesh.mesh.size.x = length
		coll.size = Vector3(length + 0.05, 4.9, 0.1)

@onready var mesh: MeshInstance3D = %Mesh
@onready var coll: BoxShape3D = %CollisionShape3D.shape
