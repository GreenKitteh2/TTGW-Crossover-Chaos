extends Label3D
class_name BattleText

# Color Library
const colors := {
	red = [Color('ff0000'), Color('7a0000')],
	green = [Color('00ff00'), Color('007100')],
	orange = [Color('ff4d00'), Color('802200')],
	yellow = [Color('ffff00'), Color('7a7a00')],
}

var raise_height: float = 0.0

func _ready():
	top_level = true
	scale = Vector3(.01, .01, .01)
	modulate = Color(modulate, 0.0)
	outline_modulate = Color(outline_modulate, 0.0)
	# Color sequence
	Sequence.new([
		Parallel.new([
			LerpProperty.new(self, ^"modulate", 0.25, Color(modulate, 1.0)).interp(Tween.EASE_OUT, Tween.TRANS_QUAD),
			LerpProperty.new(self, ^"outline_modulate", 0.25, Color(outline_modulate, 1.0)).interp(Tween.EASE_OUT, Tween.TRANS_QUAD),
			LerpProperty.new(self, ^"scale", 0.25, Vector3.ONE).interp(Tween.EASE_OUT, Tween.TRANS_QUAD),
		]),
		Wait.new(1.0),
		Parallel.new([
			LerpProperty.new(self, ^"modulate", 0.25, Color(modulate, 0.0)).interp(Tween.EASE_OUT, Tween.TRANS_QUAD),
			LerpProperty.new(self, ^"outline_modulate", 0.25, Color(outline_modulate, 0.0)).interp(Tween.EASE_OUT, Tween.TRANS_QUAD),
			LerpProperty.new(self, ^"scale", 0.25, Vector3.ONE * 0.01).interp(Tween.EASE_OUT, Tween.TRANS_QUAD),
		]),
	]).as_tween(self)
	# Position sequence
	await Sequence.new([
		LerpProperty.new(self, ^"global_position:y", 1.5, global_position.y + 1.5 + raise_height).interp(Tween.EASE_OUT, Tween.TRANS_QUAD),
	]).as_tween(self).finished
	queue_free()

func set_color_preset(color_set: Array[Color]):
	if color_set.size() < 2:
		print('Less than two colors in preset array. Returning.')
		return
	modulate = color_set[0]
	outline_modulate = color_set[1]
