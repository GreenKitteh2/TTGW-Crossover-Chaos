extends TextureRect
class_name ScrollButton


@export var options : Array[String] = []
@export var middle_button := false
@export var wrap_around := true
@export var display_option_center := true
@export var default_center_text := "Option"
@export var press_sfx : AudioStream
@export var scroll_enabled := true:
	set(x):
		scroll_enabled = x
		arrow_left.disabled = not scroll_enabled
		arrow_right.disabled = not scroll_enabled

# Child references
@onready var selection_label := $SelectionLabel
@onready var arrow_left := $ArrowLeft
@onready var arrow_right := $ArrowRight

#  Option Index
var option_index := 0:
	set(x):
		if x < 0:
			option_index = options.size()-1
		elif x >= options.size():
			option_index = 0
		else:
			option_index = x
		update()

signal s_option_changed(index : int)


func _ready():
	if display_option_center:
		selection_label.set_text(options[option_index])
	else:
		selection_label.set_text(default_center_text)
	if not wrap_around:
		arrow_left.disabled = option_index == 0
		arrow_right.disabled = option_index == options.size()-1

func menu_move(direction : bool):
	if direction:
		option_index+=1
	else:
		option_index-=1
	
	s_option_changed.emit(option_index)

func update() -> void:
	if display_option_center:
		selection_label.set_text(options[option_index])
	
	if display_option_center:
		selection_label.set_text(options[option_index])
	
	if not wrap_around:
		arrow_left.disabled = option_index == 0
		arrow_right.disabled = option_index == options.size()-1

func button_down():
	AudioManager.play_sound(press_sfx)
