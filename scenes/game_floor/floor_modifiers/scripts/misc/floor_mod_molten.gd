extends FloorModifier
const OVERHEATED_EFFECT := preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_overheated.tres")

const THERMOMETER := "res://objects/misc/thermometer/molten_thermometer.tscn"
const BUCKET_RATE := 4

var thermometer: Control
var bucket_chance := 0

const STARTER_PHRASES : Array[String] = [
	"Step aside Toon, We got a Toontown to burn.",
	"Consider yourself fired.",
	"I dedicate my work with a 'burning' passion.",
	"You're playing with fire now Toon.",
	"The pie is out of the pan and into the fire.",
	"You're fired! Alright the suit next to me is unfired, I need you.",
	"You won't get any inferno-mation here.",
	"I reached my boiling point!",
	"Has it brought to your attention I got promoted to work with a Boiler?",
	"It all hot waters here Toon.",
	"Would you be capable to afford this Bond-fire?",
]

func get_mod_name() -> String:
	return "Molten Setup"

func modify_floor() -> void:
	#thermometer = load(THERMOMETER).instantiate()
	#add_child(thermometer)
	game_floor.s_cog_spawned.connect(
		func(cog: Cog): 
			cog.s_dna_set.connect(cog_dna_set.bind(cog))
	)
	
	game_floor.environment.environment = game_floor.environment.environment.duplicate(true)
	game_floor.environment.environment.ambient_light_color = Color('ffd8bf')
	get_tree().node_added.connect(on_node_added)
	BattleService.s_battle_spawned.connect(on_battle_spawned)

func on_node_added(node: Node) -> void:
	if node is MoltenWaterBucket:
		connect_bucket(node)

func connect_bucket(bucket: MoltenWaterBucket) -> void:
	if bucket.is_queued_for_deletion(): return
	
	bucket.queue_free()
	
	#if RNG.channel(RNG.ChannelMoltenBuckets).randi() % BUCKET_RATE > bucket_chance:
		#bucket.queue_free()
		#bucket_chance += 1
		#return
	#
	#if not bucket.s_collected.is_connected(thermometer.cool_down):
		#bucket.s_collected.connect(thermometer.cool_down)
		#bucket_chance = 0

func cog_dna_set(cog : Cog) -> void:
	var new_status := OVERHEATED_EFFECT.duplicate()
	new_status.target = cog
	new_status.rounds = -1
	cog.status_effects.append(new_status)
	if RandomService.randf_channel('true_random'):
		cog.dna.battle_phrases = STARTER_PHRASES.duplicate()

func on_battle_spawned(battle: BattleNode) -> void:
	if battle.override_intro: return
	
	for cog in battle.cogs:
		if cog.dna.is_mod_cog:
			var new_movie := BattleStartMovie.new()
			new_movie.override_music = load('res://audio/music/molten_mint/liquid_metal_proxy.ogg')
			battle.override_intro = new_movie
			return
