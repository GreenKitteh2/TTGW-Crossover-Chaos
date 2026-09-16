@tool
extends StatusEffect
var hp_value := randi_range(90, 125)

func get_description() -> String:
	return "Due to their reduced volume, this Cog has " + str(hp_value) + "% of their max HP"
	
func apply() -> void:
	var new_health = (hp_value * 0.01)
	target.stats.max_hp *= new_health
	target.stats.hp *= new_health
