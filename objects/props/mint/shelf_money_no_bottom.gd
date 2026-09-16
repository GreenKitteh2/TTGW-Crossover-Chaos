@tool
extends Node3D
## Sorry but this script is just a complete copy paste of shelf_money_bags.gd because
## an older version of the mint lava room needed this scene and I just replaced it
## with the moneybags. Oops.

enum TextureType { REGULAR, HOT }

const GEOM_PREFIX := "shelf/shelf_3/geometry/"

const HOT_MAT := preload("res://models/props/facility_objects/mint/shelf/materials/moneybag_hot_mat.tres")
const REGULAR_MAT := preload("res://models/props/facility_objects/mint/shelf/materials/moneybag_regular_mat.tres")

const SHELF_PANEL_REGULAR_MAT := preload("res://models/props/facility_objects/mint/shelf/materials/shelf_panel_regular_mat.tres")
const SHELF_PANEL_HOT_MAT := preload("res://models/props/facility_objects/mint/shelf/materials/shelf_panel_hot_mat.tres")
const SHELF_BACK_REGULAR_MAT := preload("res://models/props/facility_objects/mint/shelf/materials/shelf_back_regular_mat.tres")
const SHELF_BACK_HOT_MAT := preload("res://models/props/facility_objects/mint/shelf/materials/shelf_back_hot_mat.tres")

@onready var top: MeshInstance3D = get_node(GEOM_PREFIX + "moneybag_grp/moneybag_top").get_child(0)
@onready var bag: MeshInstance3D = get_node(GEOM_PREFIX + "moneybag_grp/moneybag_bag").get_child(0)
@onready var back: MeshInstance3D = get_node(GEOM_PREFIX + "shelf/shelf_A1/polySurface2")
@onready var shelf_panels: Array[MeshInstance3D] = [
	get_node(GEOM_PREFIX + "shelf/shelf_A1/polySurface3"),
	get_node(GEOM_PREFIX + "shelf/shelf_A1/polySurface4"),
	get_node(GEOM_PREFIX + "shelf/shelf_A1/polySurface5"),
]

@export var texture_type := TextureType.REGULAR:
	set(x):
		texture_type = x
		await NodeGlobals.until_ready(self)
		update_texture()

func update_texture() -> void:
	top.set_surface_override_material(0, HOT_MAT if texture_type == TextureType.HOT else REGULAR_MAT)
	bag.set_surface_override_material(0, HOT_MAT if texture_type == TextureType.HOT else REGULAR_MAT)
	back.set_surface_override_material(0, SHELF_BACK_HOT_MAT if texture_type == TextureType.HOT else SHELF_BACK_REGULAR_MAT)
	for panel: MeshInstance3D in shelf_panels:
		panel.set_surface_override_material(0, SHELF_PANEL_HOT_MAT if texture_type == TextureType.HOT else SHELF_PANEL_REGULAR_MAT)
