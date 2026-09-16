extends Camera3D
class_name CameraTransition
## A quick util that transitions between two cameras with no additional setup required.

signal s_done

var cam_start: Camera3D
var cam_end: Camera3D
var speed: float = 1.0

var start_transform: Transform3D
var start_fov: float

var _ease := Tween.EASE_IN_OUT
var _trans := Tween.TRANS_LINEAR

var time_passed: float = 0.0

# use the static constructors thanks byeee
func _init(
		parent: Node,
		_start_cam: Camera3D,
		_end_cam: Camera3D,
		_time: float,
		_start_transform: Transform3D,
		_start_fov: float,
		_environment: Environment,
		_p_ease := Tween.EASE_IN_OUT,
		_p_trans := Tween.TRANS_QUAD,
		) -> void:
	top_level = true
	cam_end = _end_cam
	cam_start = _start_cam
	parent.add_child(self)
	start_transform = _start_transform
	global_transform = _start_transform
	fov = _start_fov
	start_fov = _start_fov
	environment = _environment
	speed = 1.0 / _time
	_ease = _p_ease
	_trans = _p_trans
	if cam_start:
		near = minf(cam_start.near, cam_end.near)
		far = maxf(cam_start.far, cam_end.far)
	reset_physics_interpolation()
	make_current()
	all_transitions.append(self)

static func from_current(parent: Node, target_camera: Camera3D, time: float, p_ease := Tween.EASE_IN_OUT, p_trans := Tween.TRANS_QUAD) -> CameraTransition:
	if not target_camera.get_viewport() or not target_camera.get_viewport().get_camera_3d():
		push_error("Backing out of camera transition because no viewport.")
		return null
	var _start_cam := target_camera.get_viewport().get_camera_3d()
	return CameraTransition.new(parent, _start_cam, target_camera, time, _start_cam.global_transform, _start_cam.fov, _start_cam.environment, p_ease, p_trans)

static func from_global_transform(parent: Node, _global_transform: Transform3D, target_camera: Camera3D, time: float, p_ease := Tween.EASE_IN_OUT, p_trans := Tween.TRANS_QUAD) -> CameraTransition:
	if not target_camera.get_viewport() or not target_camera.get_viewport().get_camera_3d():
		push_error("Backing out of camera transition because no viewport.")
		return null
	return CameraTransition.new(parent, null, target_camera, time, _global_transform, target_camera.fov, target_camera.environment, p_ease, p_trans)

func _physics_process(delta: float) -> void:
	time_passed += (delta * speed)
	if (not cam_end) or (not is_instance_valid(cam_end)) or (not cam_end.is_inside_tree()):
		finish()
		return

	var t: float = Tween.interpolate_value(0.0, 1.0, time_passed, 1.0, _trans, _ease)
	global_transform = start_transform.interpolate_with(cam_end.global_transform, t)
	fov = lerp(start_fov, cam_end.fov, t)
	if time_passed >= 1.0:
		finish()

func finish() -> void:
	set_physics_process(false)
	s_done.emit()
	destroy()

func destroy(use_end_cam: bool = true) -> void:
	if current:
		if use_end_cam and is_instance_valid(cam_end):
			cam_end.make_current()
		elif cam_start and is_instance_valid(cam_start):
			cam_start.make_current()

	if self in all_transitions:
		all_transitions.erase(self)

	queue_free()

static var all_transitions: Array[CameraTransition] = []

static func end_all_transitions() -> void:
	for transition: CameraTransition in all_transitions:
		transition.destroy()

	all_transitions = []
