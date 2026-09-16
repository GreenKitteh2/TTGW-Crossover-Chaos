extends Node3D

var emitting := true:
	set(x):
		for child in get_children():
			if child is GPUParticles3D:
				child.emitting = x
		emitting = x
