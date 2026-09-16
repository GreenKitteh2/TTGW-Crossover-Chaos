@tool
extends Node3D

const OFFSET := 0.7
const MID_FACTOR := Vector3(7.72 / 1.69, 1.0, 6.38 / 4.69)

@export var size: Vector2 = Vector2(1.0, 1.0):
	set(x):
		size = x
		if not is_node_ready():
			await ready
		hedge_north.length = size.x
		hedge_north.position = Vector3(0, 0, size.y * OFFSET)
		hedge_south.length = size.x
		hedge_south.position = Vector3(0, 0, -size.y * OFFSET)
		hedge_east.length = size.y
		hedge_east.position = Vector3(size.x * OFFSET, 0, 0)
		hedge_west.length = size.y
		hedge_west.position = Vector3(-size.x * OFFSET, 0, 0)
		middle.scale = Vector3(size.x / MID_FACTOR.x, 1.0, size.y / MID_FACTOR.z)

@onready var middle: Node3D = %Middle
@onready var hedge_north: Node3D = %RNorth
@onready var hedge_south: Node3D = %RSouth
@onready var hedge_east: Node3D = %REast
@onready var hedge_west: Node3D = %RWest
