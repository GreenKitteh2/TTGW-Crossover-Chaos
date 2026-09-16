extends Camera3D

@export var y_positions := Vector2(1.5, 1.6)
@onready var base_pos := global_position
var bounce_tween : Tween

func _ready():
	bounce_tween = create_tween()
	bounce_tween.set_trans(Tween.TRANS_BOUNCE)
	bounce_tween.set_loops()
	bounce_tween.tween_property(self,'position:y',y_positions.x,3.0)
	bounce_tween.tween_property(self,'position:y',y_positions.y,3.0)

func exit():
	bounce_tween.kill()
	var exit_tween := create_tween()
	exit_tween.set_trans(Tween.TRANS_EXPO)
	exit_tween.set_parallel(true)
	exit_tween.tween_property(self,'position:z',1.0,3.0)
	exit_tween.tween_property(self,'fov',120.0,3.0)
	await exit_tween.finished
	exit_tween.kill()
