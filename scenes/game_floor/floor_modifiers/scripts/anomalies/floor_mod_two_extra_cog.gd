extends FloorModifier

## Gives all cogs on the floor (that are grunt cogs) a random 80% to 120% HP
const COG_OBJECT := preload('res://objects/cog/cog.tscn')

func modify_floor() -> void:
	BattleService.s_battle_spawned.connect(on_battle_spawned)

func on_battle_spawned(battle: BattleNode) -> void:
	for i in range(2):
		var new_cog := COG_OBJECT.instantiate()
		new_cog.position.x += battle.cogs[battle.cogs.size() - 1].position.x + battle.COG_DISTANCE
		battle.cogs.append(new_cog)
		battle.add_child(new_cog)

func get_mod_quality() -> ModType:
	return ModType.SUPERNEGATIVE

func get_mod_name() -> String:
	return "Overhire"

func get_mod_icon() -> Texture2D:
	return load("res://ui_assets/player_ui/pause/two_extra_cog.png")

func get_description() -> String:
	return "Adds 2 extra cogs"
