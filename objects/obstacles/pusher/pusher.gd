extends Node3D

@export var automatic: bool = true  	## This should be true, unless you want to manually trigger the push via a button. The pusher will not move if looping is false.
@export var push_speed: float = 1.0  	## How fast the pusher will move.
@export var push_distance: float = 1.0  ## How far the pusher will move along the Z axis (forward).
@export var push_delay: float = 1.0  	## How long the pusher will wait before moving again.
@export var graceful_push := true		## If true, the pusher will come to a gentle stop at the start and end of its push.
@export var stop_duration: float = 1  	## How long the pusher will take to come to a stop at the start and end of its push (if graceful_push is true).

# Player detection logic mostly ripped from the stomper. We could use this for something later.
# If we want to detect when the player is pushed, uncomment and modify to suit.
#@export var collisions: Array[CollisionShape3D]
#@export var player_detection: Area3D
#var disabled := false

var start_position: Vector3
var push_position: Vector3

func _ready() -> void:
	start_position = position
	push_position = start_position + Vector3(0, 0, push_distance)
	if automatic:
		loop_push()
	
	# if player_detection:
	# 	player_detection.body_entered.connect(body_entered)
	# 	player_detection.collision_mask = Globals.PLAYER_COLLISION_LAYER

func loop_push() -> void:
	var push_tween := do_push()
	push_tween.set_loops()
	#push_tween.step_finished.connect(tween_step)

func do_push() -> Tween:
	var push_tween := create_tween()
	if graceful_push:
		push_tween.tween_property(self, 'position', start_position + Vector3(0, 0, 0.1), stop_duration)
	push_tween.tween_property(self, 'position', start_position, 1.0 / push_speed)
	push_tween.tween_interval(push_delay)
	push_tween.tween_property(self, 'position', push_position, 1.0 / push_speed)
	if graceful_push:
		push_tween.tween_property(self, 'position', push_position + Vector3(0, 0, 0.1), stop_duration)
	push_tween.tween_interval(push_delay)
	return push_tween

func connect_button(button: CogButton) -> void:
	button.s_pressed.connect(func(_button: CogButton):
		var push_tween := do_push()
		push_tween.finished.connect(button.retract)
	)

# Player detection logic mostly ripped from the stomper. We could use this for something later.
# If we want to detect when the player is pushed, uncomment and modify to suit.

# func body_entered(body: Node3D) -> void:
# 	if body is Player:
# 		player_entered(body)

# func player_entered(player: Player) -> void:
# 	disabled = true
# 	set_collisions_enabled(false)
# 	await push_player(player)

# func set_collisions_enabled(enable: bool) -> void:
# 	for shape in collisions:
# 		shape.set_disabled.call_deferred(not enable)

# func tween_step(step: int) -> void:
# 	if not player_detection:
# 		return
# 	match step:
# 		2:
# 			if disabled:
# 				disabled = false
# 				set_collisions_enabled(true)
# 			else:
# 				player_detection.set_monitoring.call_deferred(true)
# 		0:
# 			player_detection.set_monitoring.call_deferred(false)

# func push_player(player: Player) -> void:
#   pass
# 	# do something here...
