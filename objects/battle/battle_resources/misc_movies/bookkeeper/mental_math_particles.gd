extends Node3D

@onready var particles: Array = NodeGlobals.get_children_of_type(self, GPUParticles3D)

var emitting: bool:
	set(x):
		emitting = x
		await NodeGlobals.until_ready(self)
		for particle: GPUParticles3D in particles:
			particle.emitting = emitting
