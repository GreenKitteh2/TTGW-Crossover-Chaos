@tool
extends Node3D


@export_multiline var building_name: String:
	set(x):
		if not is_node_ready():
			await ready
		sign_text.set_text(x)
	get:
		return sign_text.text

## Child Refereces
@onready var sign_text := %SignText
@onready var sellbot_elevator : BuildingElevator = $suit_landmark_new_corp/locators/suit_landmark_new_corp_door_origin/GeometryTransformHelper11/sellbot_elevator

func _ready() -> void:
	if sign_text:
		sign_text.set_text(building_name)
