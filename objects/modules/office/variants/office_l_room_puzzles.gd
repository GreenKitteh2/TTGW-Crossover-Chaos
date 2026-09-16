extends Node3D

@export var puzzles : Array[Node3D]

func _ready() -> void:
	for node in puzzles:
		var puzzle := Globals.random_puzzle
		node.add_child(puzzle)
		node.get_node('CogButton').connect_to(puzzle)
		puzzle.lose_battle = node.get_node('BattleNode')
