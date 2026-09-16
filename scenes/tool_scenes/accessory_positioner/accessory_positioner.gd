extends Node3D

## Child References
@onready var toon := $Toon
@onready var spring_arm := $Toon/SpringArm3D
@onready var camera := $Toon/SpringArm3D/Camera3D
@onready var dna_editor := $GUI/EditDNA
@onready var accessory_editor := $GUI/AccessoryPlacer

## Locals
var spring_length := 5.0:
	set(x):
		spring_arm.spring_length = x
	get:
		return spring_arm.spring_length
var rotating := false

## Signals
signal s_dna_changed(dna : ToonDNA)


func _ready():
	toon.construct_toon(ToonDNA.new())
	toon.set_animation('neutral')
	spring_arm.global_position = toon.body.backpack_bone.global_position
	dna_editor.dna = toon.toon_dna
	accessory_editor.toon = toon

func _process(_delta: float) -> void:
	## Zoom Camera
	if Input.is_action_just_pressed('zoom_in'):
		spring_length-=0.25
	if Input.is_action_just_pressed('zoom_out'):
		spring_length+=0.25
	
	rotating = Input.is_action_pressed('alt_click')

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and rotating:
		spring_arm.rotate_y(-event.relative.x*Globals.SENSITIVITY)
		spring_arm.rotation.x-=event.relative.y*Globals.SENSITIVITY
		spring_arm.rotation.x = clamp(spring_arm.rotation.x,deg_to_rad(-89),deg_to_rad(89))

func dna_changed(dna : ToonDNA):
	toon.construct_toon(dna)
	toon.set_animation('neutral')
	s_dna_changed.emit(dna)
