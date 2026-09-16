extends Node3D

var emitting : bool:
	set(x):
		for child in get_children():
			child.emitting = x
		emitting = x

var lifetime : float:
	set(x):
		for child in get_children():
			child.lifetime = x
		lifetime = x

var gravity : Vector3:
	set(x):
		for child in get_children():
			child.process_material.gravity = x
		gravity = x
