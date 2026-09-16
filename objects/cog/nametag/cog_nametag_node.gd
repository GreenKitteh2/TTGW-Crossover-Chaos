extends Node3D

## Constant suit scale modifier
const SUIT_SCALE := 0.3
## Minimum scale of the nametag
const SCALE_MIN := 0.2
## Maximum scale of the nametag
const SCALE_MAX := 0.4
## How far to apply one set of scale modification?
const SCALE_DIST_MOD := 20.0
## How much is one scale mod?
const SCALE_MOD := 0.12

@onready var start_y: float = position.y
@onready var suit: Node3D = get_parent()
@onready var cog_nametag: Node3D = $CogNametag

var curr_y: float = start_y


func _ready() -> void:
	scale = Vector3.ONE * 0.2
	process_priority = 100
	if not suit.dna_set:
		await suit.s_dna_set
	if not is_equal_approx(suit.custom_nametag_height, 0.0):
		start_y = suit.custom_nametag_height

func _process(_delta: float) -> void:
	global_position = Vector3(suit.global_position.x, suit.global_position.y + (curr_y * suit.scale.x * SUIT_SCALE), suit.global_position.z)
	var viewport := get_viewport()
	if viewport:
		var cam_3d = viewport.get_camera_3d()
		if cam_3d:
			scale = Vector3.ONE * (0.2 + ((cam_3d.global_position.distance_to(global_position) / SCALE_DIST_MOD) * SCALE_MOD))

func update_position(text: String) -> void:
	curr_y = start_y
	if text.count('\n') > 1:
		curr_y += (1.0 * (text.count('\n') - 1))
