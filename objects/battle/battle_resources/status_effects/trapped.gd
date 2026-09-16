@tool
extends StatusEffect
class_name StatusTrapped

@export var gag: GagTrap

func get_status_name() -> String:
	return "Trapped (%s)" % gag.action_name

func get_description() -> String:
	return "Lure to activate the Trap"

func get_icon() -> Texture2D:
	return gag.icon
