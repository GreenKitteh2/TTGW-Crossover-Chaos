@tool
extends Node3D

@export var x_padding := 0.25
@export var y_padding := 0.15

@export_multiline var text: String:
	set(x):
		text = x
		await NodeGlobals.until_ready(self)
		label.text = x
		scale_panel()

@onready var label: Label3D = %Label3D
@onready var panel: Node3D = %Panel
@onready var chat_node: Node3D = %ChatNode

func scale_panel() -> void:
	# Calculate the bubble scale based on string size
	var text_size := label.font.get_multiline_string_size(text, HORIZONTAL_ALIGNMENT_CENTER, -1, label.font_size)
	panel.scale = Vector3((text_size.x * label.pixel_size) + x_padding, (get_line_count() * get_vertical_ratio()) + y_padding, 1.0)

func get_line_count() -> int:
	return text.count('\n') + 1

func get_vertical_ratio() -> float:
	return 185.0 * label.pixel_size
