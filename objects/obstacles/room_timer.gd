extends Node
class_name RoomTimer

@export var game_time := 30.0
@export var base_damage := -1
@export var heal_amount := 1
@export var player_death_name := "Crunch Time"

var timer: GameTimer
var game_active := false
var game_valid := true

signal s_game_won
signal s_game_lost


func start_game() -> void:
	timer = Util.run_timer(game_time)
	timer.s_timeout.connect(game_lost)
	game_active = true
	game_valid = false

func game_lost() -> void:
	if not game_active: return
	game_active = false
	Util.get_player().last_damage_source = player_death_name
	Util.get_player().quick_heal(Util.get_hazard_damage(base_damage))
	s_game_lost.emit()

func game_won() -> void:
	if not game_active: return
	game_active = false
	if is_instance_valid(timer):
		timer.queue_free()
	Util.get_player().quick_heal(heal_amount)
	s_game_won.emit()

func detect_player(body: Node3D) -> void:
	if body is Player and game_valid:
		start_game()
