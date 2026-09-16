@tool
extends MeshInstance3D

@export var color: Color = Color.WHITE:
	set(x):
		color = x
		await NodeGlobals.until_ready(self)
		mesh.material.albedo_color = color
