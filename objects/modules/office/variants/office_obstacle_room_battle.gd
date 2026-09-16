extends Node3D

@export var activated_platforms: Array[ActivatedPlatform]
var switch_pressed = false
var room_timer: RoomTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Initialize room_timer
	room_timer = RoomTimer.new()
	room_timer.game_time = 15.0
	room_timer.base_damage = 0
	room_timer.heal_amount = 0
	room_timer.s_game_lost.connect(_on_Timer_timeout)
	add_child(room_timer)
	_hide_platforms()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_Switch_pressed(_button) -> void:
	if not switch_pressed:
		switch_pressed = true
		_show_platforms()
		room_timer.start_game()

func _on_Timer_timeout() -> void:
	_hide_platforms()
	switch_pressed = false

func _show_platforms() -> void:
	for platform in activated_platforms:
		platform.show_platform()

func _hide_platforms() -> void:
	for platform in activated_platforms:
		platform.hide_platform()
