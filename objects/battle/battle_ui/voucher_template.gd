extends Control

@onready var gag_sprite: GeneralButton = $GagSprite

var is_hovered := false

var hover_seq: Tween:
	set(x):
		if hover_seq and hover_seq.is_valid():
			hover_seq.kill()
		hover_seq = x

func _ready() -> void:
	gag_sprite.mouse_entered.connect(hover)
	gag_sprite.mouse_exited.connect(stop_hover)

func hover() -> void:
	is_hovered = true
	if not gag_sprite.disabled:
		hover_seq = Sequence.new([
			LerpProperty.new(gag_sprite, ^"scale", 0.1, Vector2.ONE * 1.15).interp(Tween.EASE_IN_OUT, Tween.TRANS_QUAD),
		]).as_tween(self)

func stop_hover() -> void:
	is_hovered = false
	hover_seq = Parallel.new([
		LerpProperty.new(gag_sprite, ^"scale", 0.1, Vector2.ONE).interp(Tween.EASE_IN_OUT, Tween.TRANS_QUAD),
	]).as_tween(self)
