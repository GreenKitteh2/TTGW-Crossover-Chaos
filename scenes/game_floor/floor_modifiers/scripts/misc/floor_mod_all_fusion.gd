extends FloorModifier

## Turns all Cogs on floor into fusions
func modify_floor() -> void:
	game_floor.s_cog_spawned.connect(
		func(cog: Cog): 
			if cog.fusion_chance >= 0:
				cog.fusion = true
				cog.skelecog_chance = 0
				cog.skelecog = false
	)

func get_mod_name() -> String:
	return "AllFusionCogs"
