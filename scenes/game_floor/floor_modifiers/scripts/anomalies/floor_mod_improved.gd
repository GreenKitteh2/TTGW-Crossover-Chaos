extends FloorModifier

## Gives all cogs on the floor (that are grunt cogs) a random 80% to 120% HP
func modify_floor() -> void:
	game_floor.s_cog_spawned.connect(
		func(cog: Cog):
			var health_mod := 1.5
			print('Improved Materials - Applying health mod: %s' % health_mod)
			cog.health_mod *= health_mod
	)

func get_mod_quality() -> ModType:
	return ModType.NEGATIVE

func get_mod_name() -> String:
	return "Improved Materials"

func get_mod_icon() -> Texture2D:
	return load("res://ui_assets/player_ui/pause/Improved.png")

func get_description() -> String:
	return "Cog HP increased"
