@tool
extends StatusEffect
var hp_value := randi_range(70, 110)

func get_description() -> String:
	return "This Cog's hardware has been virtualized! Due to their abstract nature, they have " + str(hp_value) + "% of their max HP"
	
func apply() -> void:
	var new_health = (hp_value * 0.01)
	target.stats.max_hp *= new_health
	target.stats.hp *= new_health
