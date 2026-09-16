extends Node3D
class_name RhythmPlatformController

const FALLBACK_COLORS : Array[Color] = [Color.RED, Color.ORANGE, Color.YELLOW, Color.GREEN, Color.BLUE, Color.INDIGO, Color.VIOLET]

@export var platforms : Array[RhythmPlatform]
@export var group_colors : Array[Color]
@export var group_current := 0

var highest_group := 0



func _ready() -> void:
	if group_colors.is_empty(): group_colors = FALLBACK_COLORS
	for platform in platforms:
		if platform.platform_group > highest_group:
			highest_group = platform.platform_group
		platform.set_color(group_colors[min(platform.platform_group, group_colors.size() -1)])
	set_group(group_current)

func set_group(group : int) -> void:
	group_current = group
	if group_current > highest_group:
		group_current = 0
	for platform in platforms:
		platform.set_enabled(platform.platform_group == group_current)
