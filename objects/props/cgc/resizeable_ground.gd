@tool
extends Node3D

@export var size := Vector2.ONE:
	set(x):
		size = x
		if not is_node_ready():
			await ready
		ground.size = size
		coll.shape.size = Vector3(size.x, 0.01, size.y)

@onready var ground: Node3D = %ground
@onready var coll: CollisionShape3D = %Coll
