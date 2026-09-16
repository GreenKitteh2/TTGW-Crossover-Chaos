extends 'res://objects/items/custom/seed_logic/custom_seed_base.gd'
var hard_mode := "res://scenes/game_floor/floor_modifiers/scripts/anomalies/floor_mod_hard_mode.gd"

const COG_OBJECT := preload('res://objects/cog/cog.tscn')

func setup() -> void:
	Util.get_player().stats.crossover_chance_boost = 1
	Util.s_floor_started.connect(on_floor_started)
	BattleService.s_battle_spawned.connect(on_battle_spawned)

func on_floor_started(gfloor: GameFloor) -> void:
	await get_tree().process_frame
	var node := Node.new()
	node.set_script(load(hard_mode))
	add_child(node)
	node.game_floor = gfloor
	node.modify_floor()
	node.queue_free()

func on_battle_spawned(battle: BattleNode) -> void:
	for i in 3:
		var new_cog := COG_OBJECT.instantiate()
		new_cog.position.x += battle.cogs[battle.cogs.size() - 1].position.x + battle.COG_DISTANCE
		battle.cogs.append(new_cog)
		battle.add_child(new_cog)

func on_collect(_item: Item, _object: Node3D) -> void:
	Util.get_player().stats.manager_chance_boost = 0.1
	Util.get_player().stats.max_hp = (Util.get_player().stats.max_hp * 2)
	Util.get_player().stats.hp = (Util.get_player().stats.hp * 2)
