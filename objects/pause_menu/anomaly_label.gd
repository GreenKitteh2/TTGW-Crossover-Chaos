extends Label

var FloorColors: Dictionary = {
	FloorModifier.ModType.SUPERPOSITIVE: [Color.html("00e06b"), Color.GREEN],
	FloorModifier.ModType.POSITIVE: [Color.GREEN, Color.DARK_GREEN],
	FloorModifier.ModType.NEGATIVE: [Color.RED, Color.DARK_RED],
	FloorModifier.ModType.NEUTRAL: [Color.html("ff7900"), Color.html("6f3100")],
	FloorModifier.ModType.SUPERNEGATIVE: [Color.DARK_RED, Color.RED],
}

@export var floor_mod: FloorModifier:
	set(x):
		floor_mod = x
		if not is_node_ready():
			await ready
		var mod_array: Array = FloorColors[floor_mod.get_mod_quality()]
		text = floor_mod.get_mod_name()
		label_settings.font_color = mod_array[0]
		label_settings.shadow_color = mod_array[1]
