@tool
extends Control

const PANEL_BUFFER := Vector2(16,16)

@onready var label : Label = $Label

@export_multiline var text := "":
	set(x):
		set_text(x)
	get:
		return $Label.get_text()


func set_text(text : String) -> void:
	if not is_instance_valid(label):
		return
	if not label.is_node_ready():
		await label.ready
	label.set_text(text)
	resize_panel(text)

func resize_panel(text : String) -> void:
	var label_size := label.label_settings.font.get_multiline_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, label.size.x, label.label_settings.font_size)
	$Panel.size = label_size + PANEL_BUFFER
	$Panel.position = -(PANEL_BUFFER / 2.0)
