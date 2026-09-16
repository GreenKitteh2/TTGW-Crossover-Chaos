extends Elevator
class_name BuildingElevator

const FLOOR_MAT_OFF := preload("res://models/props/facility_objects/transporters/sellbot_elevator/floor_light_off.tres")
const FLOOR_MAT_ON := preload("res://models/props/facility_objects/transporters/sellbot_elevator/floor_light_on.tres")

## Config
@export_range(1,5) var floor_count : int = 1:
	set(x):
		floor_count = x
		update_lights()
@export_range(0,6) var floor_current : int = 0:
	set(x):
		floor_current = x
		update_lights()
@export var floor_lights : Array[MeshInstance3D]
@export var sync_to_floor := false



func _ready() -> void:
	if sync_to_floor:
		floor_sync()
	
	update_lights()
	
	super()


func update_lights() -> void:
	# Apply the materials and hide additional floors
	for light in floor_lights:
		if floor_count-1 < floor_lights.find(light):
			light.hide()
		
		if floor_current - 1 == floor_lights.find(light) or floor_current == 6:
			light.set_surface_override_material(0, FLOOR_MAT_ON)
		else:
			light.set_surface_override_material(0, FLOOR_MAT_OFF)

func floor_sync() -> void:
	floor_count = 5
	floor_current = Util.floor_number
