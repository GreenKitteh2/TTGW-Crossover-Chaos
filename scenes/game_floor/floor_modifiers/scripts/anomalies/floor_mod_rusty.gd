extends FloorModifier

## Gives all cogs on the floor
func modify_floor() -> void:
	game_floor.s_cog_spawned.connect(
		func(cog: Cog):
			var health_mod := 0.5
			print('Rusty Manufacturing - Applying health mod: %s' % health_mod)
			cog.health_mod *= health_mod
	)

func get_mod_quality() -> ModType:
	return ModType.POSITIVE

func get_mod_name() -> String:
	return "Rusty Manufacturing"

func get_mod_icon() -> Texture2D:
	return load("res://ui_assets/player_ui/pause/Rusty.png")

func get_description() -> String:
	return "Cog HP Decreased"
