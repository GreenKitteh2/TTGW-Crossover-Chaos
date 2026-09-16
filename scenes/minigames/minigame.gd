extends Node
class_name MiniGame

const INSTRUCTIONS := preload("res://scenes/minigames/minigame_rule_panel.tscn")

## General Configuration
@export var game_title := ""
@export_multiline var game_summary := ""
@export var reward_ratio := 2.0

## Signals
signal s_game_won
signal s_game_lost
signal s_game_partial(ratio : float)

## Reference values
var difficulty := 0
var bean_deposit := 0


## DO NOT OVERWRITE
func _ready() -> void:
	_initialize()
	_show_rules()

func _show_rules() -> void:
	var instruction_panel := INSTRUCTIONS.instantiate()
	add_child(instruction_panel)
	instruction_panel.get_node('GameTitle').set_text(game_title)
	instruction_panel.get_node('GameSummary').set_text(game_summary)
	instruction_panel.get_node('GoButton').pressed.connect(
	func():
		instruction_panel.queue_free()
		start_game()
	)


## Runs immediately
func _initialize() -> void:
	pass

## Runs upon instruction panel dismissal
func start_game() -> void:
	pass
