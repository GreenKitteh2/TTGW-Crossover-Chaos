extends CogAttack

const COG_OBJECT := preload('res://objects/cog/cog.tscn')

var spawn_proxies := false
var elite_chance := 10
var cogs := [
	"res://objects/cog/presets/crossover_cogs/misc/normal/starman_jr.tres",
	"res://objects/cog/presets/crossover_cogs/misc/normal/starman.tres",
	"res://objects/cog/presets/crossover_cogs/misc/normal/blue_starman.tres",
	"res://objects/cog/presets/crossover_cogs/misc/normal/last_starman.tres",
	"res://objects/cog/presets/crossover_cogs/misc/normal/starman_super.tres",
	"res://objects/cog/presets/crossover_cogs/misc/normal/starman_deluxe.tres",
	"res://objects/cog/presets/crossover_cogs/misc/normal/ghost_of_starman.tres",
	"res://objects/cog/presets/crossover_cogs/misc/normal/final_starman.tres",
]
var elite_cogs := [
	"res://objects/cog/presets/crossover_cogs/misc/elite/starman_jr.tres",
	"res://objects/cog/presets/crossover_cogs/misc/elite/starman.tres",
	"res://objects/cog/presets/crossover_cogs/misc/elite/blue_starman.tres",
	"res://objects/cog/presets/crossover_cogs/misc/elite/last_starman.tres",
	"res://objects/cog/presets/crossover_cogs/misc/elite/starman_super.tres",
	"res://objects/cog/presets/crossover_cogs/misc/elite/starman_deluxe.tres",
	"res://objects/cog/presets/crossover_cogs/misc/elite/ghost_of_starman.tres",
	"res://objects/cog/presets/crossover_cogs/misc/elite/final_starman.tres",
]

func action() -> void:
	var cognum := Vector2i(1, 3) 
	var cog_amount := RandomService.randi_range_channel('cognum', cognum.x, cognum.y)
	if len(manager.cogs) >= 5:
		return
	var user_cog : Cog = user
	
	battle_node.focus_character(user_cog)
	await manager.sleep(3.0)
	
	var new_cogs : Array[Cog] = []
	
	# Create our new Cog objects
	for i in cog_amount:
		var new_cog := COG_OBJECT.instantiate()
		if spawn_proxies:
			new_cog.use_mod_cogs_pool = true
			new_cog.level_range_offset = -1
		if RNG.channel(RNG.ChannelSkelecogChance).randi() % 100 < elite_chance:
			new_cog.dna = load(elite_cogs[RandomService.randi_channel('true_random') % elite_cogs.size()])
		else:
			new_cog.dna = load(cogs[RandomService.randi_channel('true_random') % cogs.size()])
		new_cogs.append(new_cog)
		new_cog.hide()
		battle_node.add_child(new_cog)
		new_cog.battle_start()
		BattleService.ongoing_battle.add_cog(new_cog)
	
	for cog : Cog in battle_node.cogs:
		if cog in new_cogs:
			cog.global_position = battle_node.get_cog_position(cog)
			battle_node.face_battle_center(cog)
			cog.fly_in(20.0, 0.0)
			cog.show()
		else:
			cog.move_to(battle_node.get_cog_position(cog)).finished.connect(func(): battle_node.face_battle_center(cog))
	
	battle_node.focus_cogs()
	battle_node.battle_cam.position.z += 2.0
	await manager.sleep(5.0)
	
