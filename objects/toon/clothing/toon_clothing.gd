extends Resource
class_name ToonClothing

enum ColorType {
	RECOLORABLE,
	STATIC
}
@export var color_type := ColorType.RECOLORABLE

func set_color(_color : Color) -> void:
	pass
