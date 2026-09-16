@tool
extends TextureRect

@export var camera : Camera3D
@export var model : MeshInstance3D
@export var test := false:
	set(x):
		if x:
			adjust_cam()
		test = false

@onready var sub_viewport: SubViewport = %SubViewport

func adjust_cam():
	if not model:
		return
	
	var aabb := model.get_aabb()
	
	
	# Calculate model camera size
	var model_size : Vector3 = aabb.size*model.scale
	var cam_size : float = max(model_size.x,model_size.y)/2.0
	camera.size = cam_size*2.0
	
	# Move camera to model position and then back to avoid clipping
	camera.position = aabb.get_center()*model.scale
	camera.position.z-=10.0
