extends Node3D

@export var automatic := true

var made_chests := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if automatic:
		make_chests()

func make_chests() -> void:
	if not made_chests:
		Util.make_boss_chests(self, self)
		made_chests = true
