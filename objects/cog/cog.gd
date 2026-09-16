extends Actor
class_name Cog

signal s_dna_set

## Constants
const VIRTUAL_COG_COLOR := Color('ff0000cc')
const GHOST_COG_COLOR := Color("ffffffcc")
const EXE_COG_COLOR := Color('3d3d3d')
const health_skele := "res://objects/battle/battle_resources/status_effects/resources/status_effect_skeletal_structure.tres"
const health_virutal := "res://objects/battle/battle_resources/status_effects/resources/status_effect_virtualized.tres"
const overcharge := "res://objects/battle/battle_resources/status_effects/resources/status_effect_overcharged.tres"
const COMMON_LEVEL_RANGE := Vector2i(1, 12)
var QUEST_HELP_CHANCE := 20

## For flying in and out
const PROP_PROPELLER := preload('res://objects/props/etc/cog_propeller.tscn')
const SFX_FLY_IN := preload("res://audio/sfx/battle/cogs/misc/ENC_propeller_in.ogg")
const SFX_FLY_OUT := preload("res://audio/sfx/battle/cogs/misc/ENC_propeller_out.ogg")

# Object state
enum CogState {
	IDLE,
	BATTLE,
	PATH
}
@export var state := CogState.IDLE
@export_range(0, 20) var level: int:
	set(x):
		if x < 0: level = 0
		else: level = x
@export var custom_level_range := Vector2i(1, 12)
@export var overcog_range := Vector2i(1, 4)
@export var level_range_offset := 0
@export var stats: BattleStats
@export var pool: CogPool
@export var use_floor_pool := true

# CogDNA
@export var dna: CogDNA
var dna_set := false
var attacks: Array[CogAttack]
var status_effects: Array[StatusEffect]
var zen_dna : CogPool
@export var female := false
@export var intern_chance := 25
@export var elite_chance := 0
@export var omnipotent_chance := 0
@export var boss_cog_chance := 0
@export var skelecog := false
@export var skelecog_chance := 10
@export var fusion := false
@export var fusion_chance := 0
@export var virtual_cog := false
@export var ghost_cog := false
@export var crossover_cog := false
@export var v2 := false
@export var v3 := false
@export var exe := false
@export var exe_chance := 25
@export var overcog := false
@export var overcog_chance := 25
@export var overcog_value := 0
@export var health_mod := 1.0

## Marks this Cog as not to be counted for Quests/Item benefits
@export var is_punishment_cog := false

var use_mod_cogs_pool := false
var use_crossover_cogs_pool := false
var use_muffet_to_ruin_peoples_days := false
var use_manager_cogs_pool := false
var has_forced_dna := false

# Movement Speed
var walk_speed := 4.0
var spd := 1.0 # Actual speed value

# Optional walking path
@export var path: Path3D

# Body
@onready var body_root := $Body
@onready var drop_shadow: RayCast3D = %DropShadow
@onready var path_follow: PathFollow3D = $PathFollower
@onready var starting_pos := position

var body: Node3D

# Locals
var animator: AnimationPlayer
var skeleton: Skeleton3D
var path_positions := {}
var next_point := 1
var turn_tween: Tween

# Emblem/Health Light
var department_emblem: Sprite3D
var hp_light: MeshInstance3D
var light_tween: Tween
var body_tween: Tween

# Head position
var head_node: Node3D

# Battle values
var lured := false
var stunned := false
var trap: GagTrap
var losing := false

# Child references
@onready var sfx := $CogDial

var grunt: AudioStream
var murmur: AudioStream
var statement: AudioStream
var question: AudioStream
var question_long: AudioStream

## REGULAR COG VO:
const GRUNT := preload("res://audio/sfx/battle/cogs/COG_VO_grunt.ogg")
const MURMUR := preload("res://audio/sfx/battle/cogs/COG_VO_murmur.ogg")
const STATEMENT := preload("res://audio/sfx/battle/cogs/COG_VO_statement.ogg")
const QUESTION := preload("res://audio/sfx/battle/cogs/COG_VO_question.ogg")
const QUESTION_LONG := preload("res://audio/sfx/battle/cogs/COG_VO_question_old.ogg")
const F_GRUNT := preload("res://audio/sfx/battle/cogs/COG_VO_grunt_f.ogg")
const F_MURMUR := preload("res://audio/sfx/battle/cogs/COG_VO_murmur_f.ogg")
const F_STATEMENT := preload("res://audio/sfx/battle/cogs/COG_VO_statement_f.ogg")
const F_QUESTION := preload("res://audio/sfx/battle/cogs/COG_VO_question_f.ogg")
const F_QUESTION_LONG := preload("res://audio/sfx/battle/cogs/COG_VO_question_old_f.ogg")

## SKELECOG VO:
const SKELE_GRUNT := preload("res://audio/sfx/battle/cogs/Skel_COG_VO_grunt.ogg")
const SKELE_MURMUR := preload("res://audio/sfx/battle/cogs/Skel_COG_VO_murmur.ogg")
const SKELE_STATEMENT := preload("res://audio/sfx/battle/cogs/Skel_COG_VO_statement.ogg")
const SKELE_QUESTION := preload("res://audio/sfx/battle/cogs/Skel_COG_VO_question.ogg")
const F_SKELE_GRUNT := preload("res://audio/sfx/battle/cogs/Skel_COG_VO_grunt_f.ogg")
const F_SKELE_MURMUR := preload("res://audio/sfx/battle/cogs/Skel_COG_VO_murmur_f.ogg")
const F_SKELE_STATEMENT := preload("res://audio/sfx/battle/cogs/Skel_COG_VO_statement_f.ogg")
const F_SKELE_QUESTION := preload("res://audio/sfx/battle/cogs/Skel_COG_VO_question_f.ogg")

func _ready():
	# Announce Cog's existence
	if is_instance_valid(Util.floor_manager):
		Util.floor_manager.s_cog_spawned.emit(self)
	print("running randomize cog")
	# Create a Cog based on the game's current parameters
	randomize_cog()
	if state == CogState.PATH:
		const _QUEST_HELP_CHANCE := 0
		zen()

func zen():
	_refresh_cog()
	randomize_cog()
	set_path(path)
	spd = 0
	fly_in()
	await get_tree().create_timer(randi_range(10, 30)).timeout
	spd = 0.027
	if randi_range(1, 10) < 7:
		speak(dna.battle_phrases.pick_random())
	set_animation('walk')
	await get_tree().create_timer(randi_range(20, 60)).timeout
	spd = 0
	fly_out()
	await get_tree().create_timer(10).timeout
	zen()

func _refresh_cog() -> void:
	skelecog = false
	ghost_cog = false
	virtual_cog = false
	v2 = false
	v3 = false
	if RNG.channel(RNG.ChannelSkelecogChance).randi() % 100 < 5:
		skelecog = true
	if RNG.channel(RNG.ChannelSkelecogChance).randi() % 100 < 5:
		ghost_cog = true
	if RNG.channel(RNG.ChannelSkelecogChance).randi() % 100 < 5:
		virtual_cog = true
	if RNG.channel(RNG.ChannelSkelecogChance).randi() % 100 < 5:
		v2 = true
	if RNG.channel(RNG.ChannelSkelecogChance).randi() % 100 < 5:
		v3 = true
	pool = Globals.ALL_COG_POOL
	dna = pool.cogs[RNG.channel(RNG.ChannelCogDNA).randi() % pool.cogs.size()]
	set_dna(dna)
	set_animation('neutral')
	
func set_path(new_path: Path3D) -> void:
	# Set the new path to the path variable
	path = new_path
	
	# Add the path follower as a child to the path
	path_follow.reparent(path)
	
	# Gather path info
	var path_length := 0.0
	var curve := path.curve
	var line_lengths: Array[float] = []
	
	for i in curve.point_count:
		# Get the point in the curve
		var point := curve.get_point_position(i)
		
		# Get the length from the previous point
		var length: float
		if i > 0:
			length = abs(point.distance_to(curve.get_point_position(i - 1)))
		else:
			length = 0.0
		path_length += length
		line_lengths.append(path_length)
	
	# Get the progress ratios for each point
	for length in line_lengths:
		path_positions[length / path_length] =  curve.get_point_position(line_lengths.find(length))
	
	spd *= walk_speed / path_length
	
	rotation.y = get_rotation_to(curve.get_point_position(next_point))

func _physics_process(delta) -> void:
	match state:
		CogState.PATH:
			# Follow path
			path_follow.progress_ratio += spd * delta
			position = starting_pos + (path_follow.position)
			
			# Detect when a point is reached
			if not next_point == 0:
				if path_follow.progress_ratio > path_positions.keys()[next_point]:
					point_reached()
			else:
				if path_follow.progress_ratio < path_positions.keys()[1]:
					point_reached()

func point_reached() -> void:
	# Increment point
	next_point += 1
	if next_point == path_positions.keys().size() - 1:
		next_point = 0
	
	# Turn to face the next position
	turn_tween = create_tween()
	turn_tween.tween_property(self, 'rotation:y', get_rotation_to(path.curve.get_point_position(next_point)), 0)
	
	# After tween is finished, go back to walk state
	await turn_tween.finished
	turn_tween.kill()


func get_rotation_to(point: Vector3) -> float:
	path_follow.position = point
	var prev_rot := rotation
	look_at(path_follow.global_position)
	var rot := rotation.y + deg_to_rad(180.0)
	rotation = prev_rot
	return rot

func face_position(pos: Vector3):
	var face_pos := Vector3(pos.x, global_position.y, pos.z)
	if global_position != face_pos:
		look_at(face_pos)
		rotate_y(deg_to_rad(180))

func randomize_cog() -> void:
	roll_for_attributes()
	roll_for_level()
	roll_for_dna()
	attacks = _get_attacks()
	status_effects = _get_status_effects()
	construct_cog()
	set_animation('neutral')
	set_up_stats()
	if skelecog:
		if dna.is_female_cog:
			grunt = F_SKELE_GRUNT
			murmur = F_SKELE_MURMUR
			statement = F_SKELE_STATEMENT
			question = F_SKELE_QUESTION
			question_long = F_SKELE_QUESTION
		else:
			grunt = SKELE_GRUNT
			murmur = SKELE_MURMUR
			statement = SKELE_STATEMENT
			question = SKELE_QUESTION
			question_long = SKELE_QUESTION
	else:
		if dna.is_female_cog:
			grunt = F_GRUNT
			murmur = F_MURMUR
			statement = F_STATEMENT
			question = F_QUESTION
			question_long = F_QUESTION_LONG
		else:
			grunt = GRUNT
			murmur = MURMUR
			statement = STATEMENT
			question = QUESTION
			question_long = QUESTION_LONG

func set_dna(cog_dna: CogDNA, full_reset := true) -> void:
	dna = cog_dna
	if full_reset:
		level = 0
		roll_for_attributes()
		roll_for_level()
		if dna.cog_name == "Public Relations Representative":
			grunt = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_dopr_grunt_skel.ogg")
			murmur = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_dopr_murmur_skel.ogg")
			statement = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_dopr_statement_skel.ogg")
			question = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_dopr_question_skel.ogg")
			question_long = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_dopr_question_skel.ogg")
		if dna.cog_name == "Director Of Public Affairs":
			grunt = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_dopa_grunt_skel.ogg")
			murmur = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_dopa_murmur_skel.ogg")
			statement = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_dopa_statement_skel.ogg")
			question = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_dopa_question_skel.ogg")
			question_long = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_dopa_question_skel.ogg")
		if dna.cog_name == "Bookkeeper" or dna.cog_name == "Whistleblower":
			female = true
			grunt = F_GRUNT
			murmur = F_MURMUR
			statement = F_STATEMENT
			question = F_QUESTION
			question_long = F_QUESTION_LONG
	attacks = _get_attacks()
	status_effects = _get_status_effects()
	construct_cog()
	set_up_stats()

func roll_for_attributes() -> void:
	# Skelecog perchance?
	if RNG.channel(RNG.ChannelSkelecogChance).randi() % 100 < skelecog_chance:
		skelecog = true
	if RNG.channel(RNG.ChannelSkelecogChance).randi() % 100 < exe_chance:
		exe = true
	if RNG.channel(RNG.ChannelSkelecogChance).randi() % 100 < overcog_chance:
		overcog = true
	
	# Mayhaps even... fusion?
	if not skelecog and RNG.channel(RNG.ChannelFusionChance).randi() % 100 < fusion_chance:
		fusion = true

func roll_for_level() -> void:
	# Get a random cog level first
	if level == 0:
		if is_instance_valid(Util.floor_manager):
			custom_level_range = Util.floor_manager.level_range
		elif dna: 
			custom_level_range = Vector2i(dna.level_low, dna.level_high)
		level = RNG.channel(RNG.ChannelCogLevels).randi_range(custom_level_range.x, custom_level_range.y)
		overcog_value = RandomService.randi_range_channel('overcog_levels', overcog_range.x, overcog_range.y)
	
	# Allow for Cogs to be higher/lower level than the floor intends
	if not signi(level_range_offset) == 0:
		level = custom_level_range.y + level_range_offset

func roll_for_dna() -> void:
	pool = Globals.GRUNT_COG_POOL  # Default
	if use_mod_cogs_pool:
		pool = Globals.MOD_COG_POOL
	if Util.floor_number > 1:
		elite_chance = 20
	if Util.floor_number > 2:
		omnipotent_chance = 20
	if Util.floor_number > 4:
		boss_cog_chance = 20
	if use_crossover_cogs_pool:
		if RandomService.randi_channel('boss_cog_chance') % 100 < boss_cog_chance and level > 11:
			boss_cog_chance = 0
			omnipotent_chance = 0
			intern_chance = 0
			elite_chance = 0
			pool = Globals.BOSS_COG_POOL
			print("Boss Cog Spawned")
			female = false
		elif RandomService.randi_channel('omnipotent_chance') % 100 < omnipotent_chance:
			boss_cog_chance = 0
			omnipotent_chance = 0
			intern_chance = 0
			elite_chance = 0
			pool = Globals.OMNIPOTENT_COG_POOL
			print("Omnipotent Spawned")
			female = false
		elif RandomService.randi_channel('elite_chance') % 100 < elite_chance:
			boss_cog_chance = 0
			omnipotent_chance = 0
			intern_chance = 0
			elite_chance = 0
			pool = Globals.ELITE_COG_POOL
			print("Elite Spawned")
			female = false
		elif RandomService.randi_channel('intern_chance') % 100 < intern_chance:
			boss_cog_chance = 0
			omnipotent_chance = 0
			intern_chance = 0
			elite_chance = 0
			pool = Globals.INTERN_COG_POOL
			print("Intern Spawned")
			health_mod = 1.0
			female = false
		else:
			pool = Globals.CROSSOVER_COG_POOL
			print("Crossover Cog Spawned")
			health_mod = 1.0
			female = false
	if use_manager_cogs_pool and level > 4:
		pool = Globals.MANAGER_COG_POOL
		print("Manager Spawned")
	if use_muffet_to_ruin_peoples_days:
		pool = Globals.Muffet_Cog
		print("Muffet Spawned")
	# Try to get the cog pool from the floor manager
	elif use_floor_pool:
		if is_instance_valid(Util.floor_manager) and Util.floor_manager.cog_pool and not use_crossover_cogs_pool and not use_manager_cogs_pool:
			if RNG.channel(RNG.ChannelCogPoolChance).randi() % 4 == 0:
				pool = Util.floor_manager.cog_pool
	
	# Make it more likely for quest related Cogs to appear
	if (not dna) and randi() % 100 < QUEST_HELP_CHANCE and is_instance_valid(Util.get_player()) and not use_crossover_cogs_pool and not use_manager_cogs_pool:
		print('attempting to spawn task cog')
		var player := Util.get_player()
		if not player.stats.quests.is_empty():
			var quest := player.stats.quests[randi() % player.stats.quests.size()]
			if quest is QuestCog:
				if quest.specific_cog and test_dna(quest.specific_cog, level):
					print('spawning task cog')
					health_mod = 1.0
					dna = quest.specific_cog
				else:
					if not quest.specific_cog: print('quest not specific cog')
					else: print('dna test failed')

	# Get a random dna if dna doesn't exist
	if not dna:
		while not test_dna(dna, level):
			dna = pool.cogs[RNG.channel(RNG.ChannelCogDNA).randi() % pool.cogs.size()]
	else:
		has_forced_dna = true
	
	dna = dna.duplicate(true)
	
	if dna.is_manager:
		exe = false
		overcog = false
		skelecog = false
	else:
		exe = exe
		overcog = overcog
		skelecog = skelecog
		
func _get_attacks() -> Array[CogAttack]:
	var atk: Array[CogAttack] = []
	atk = dna.attacks
	return atk

func get_debug_attack() -> CogAttack:
	var failsafe_attack: CogAttack = load("res://objects/battle/battle_resources/cog_attacks/pickpocket.gd").new()
	failsafe_attack.action_name = "ERR: COG HAS NO ATTACKS"
	failsafe_attack.summary = "This is actually a bug."
	failsafe_attack.attack_lines = ["Boy, I really hope someone got fired for that blunder."]
	failsafe_attack.user = self
	failsafe_attack.targets = get_targets(failsafe_attack.target_type)
	return

func _get_status_effects() -> Array[StatusEffect]:
	return dna.instantiate_status_effects()

## Scales the Cog's stats based on its level
func set_up_stats() -> void:
	var damage_value = 0.4
	if not stats: stats = BattleStats.new()
	stats.allow_overheal = true
	if dna.is_mod_cog:
		health_mod = 1.0
		health_mod *= Util.get_mod_cog_health_mod()
		if Util.get_player() and not is_equal_approx(Util.get_player().stats.proxy_health_mod, 0.0):
			health_mod *= Util.get_player().stats.proxy_health_mod
	if dna.is_crossover_cog:
		stats.max_hp = (level + 3) * (level + 4)
	else:
		stats.max_hp = (level + 1) * (level + 2)
	if exe:
		damage_value = 0.4
		health_mod += 0.5
	if overcog:
		health_mod += (overcog_value * 0.1)
	if not is_equal_approx(dna.health_mod, 1.0): 
		health_mod *= dna.health_mod
	if not is_equal_approx(health_mod, 1.0):
		stats.max_hp = ceili(stats.max_hp * health_mod)
	stats.hp = stats.max_hp
	stats.evasiveness = 0.5 + (level * 0.05)
	stats.damage = damage_value + (level * 0.13)
	stats.accuracy = 0.75 + (level * 0.05)
	var new_text: String = dna.cog_name + '\n'
	new_text += 'Level ' + str(level)
	if exe: new_text += ".exe"
	if dna.is_manager: new_text += ".mgr"
	if overcog and not v2 and not v3: new_text += " v1."
	if v3: 
		v2 = false
		new_text += " v3."
		if not overcog: new_text += '0'
	if v2: 
		new_text += " v2."
		if not overcog: new_text += '0'
	if overcog: new_text += str(overcog_value)
	if dna.is_mod_cog: new_text += '\nProxy'
	if dna.is_admin: new_text += '\nAdministrator'
	if dna.custom_nametag_suffix: new_text += '\n%s' % dna.custom_nametag_suffix
	body.nametag.text = new_text
	body.nametag_node.update_position(new_text)
	if not stats.hp_changed.is_connected(update_health_light):
		stats.hp_changed.connect(update_health_light.unbind(1))

## Validates DNA and level combinations
static func test_dna(cog_dna: CogDNA, cog_level: int) -> bool:
	if cog_dna == null:
		return false
	
	# Let Cogs exist outside the standard level range if they want to
	if not cog_level in range(COMMON_LEVEL_RANGE.x, COMMON_LEVEL_RANGE.y + 1):
		return true
	
	# If DNA exists and we are in standard range
	# Return whether or not the cog level is within the dna's level range
	return cog_level in range(cog_dna.level_low, cog_dna.level_high + 1)

func construct_cog():
	# Preserve our drop shadow
	if not drop_shadow.get_parent() == self:
		drop_shadow.reparent(self)
	
	# Allow Cog DNA to be refreshed and reset
	if body:
		body.queue_free()
	
	# Some Cog shaders want to change aspects of a Cog's DNA before building
	if dna.head_shader:
		dna.head_shader = dna.head_shader.duplicate(true)
		dna.head_shader.tweak_cog(self)
	
	if fusion:
		dna = dna.duplicate(true)
		var second_dna: CogDNA 
		while not second_dna or second_dna.cog_name == dna.cog_name:
			second_dna = pool.cogs[RNG.channel(RNG.ChannelCogDNA).randi() % pool.cogs.size()].duplicate(true)
		dna.combine_attributes(second_dna)
		dna.cog_name = dna.combine_names(second_dna)
	
	# First, get the body
	body = Globals.fetch_suit(dna.suit, skelecog).instantiate()
	match dna.suit:
		CogDNA.SuitType.SUIT_A:
			body.scale /= 6.06
		CogDNA.SuitType.SUIT_B:
			body.scale /= 5.29
		CogDNA.SuitType.SUIT_C:
			body.scale /= 4.14
	body_root.add_child(body)
	
	if dna.head_shader and dna.head_shader.has_method('randomize_shader'):
		dna.head_shader.randomize_shader()
	
	# Set the body's dna
	body.set_dna(dna)
	
	skeleton = body.skeleton
	animator = body.animator
	animator.animation_finished.connect(animation_end)
	
	# Get the department emblem
	department_emblem = body.department_emblem
	hp_light = body.health_meter
	if ghost_cog:
		body.set_color(GHOST_COG_COLOR)
		if exe:
			body.set_color(Color("3d3d3dcc"))
	if virtual_cog:
		body.set_color(Color("00ff00cc"))
	if exe:
		if skelecog:
			if virtual_cog:
				body.set_color(Color("00ff00cc"))
			else:
				match dna.department:
					CogDNA.CogDept.SELL: body.set_color(Color("e886bfff"))
					CogDNA.CogDept.CASH: body.set_color(Color("6bf379ff"))
					CogDNA.CogDept.LAW: body.set_color(Color("85b0ffff"))
					CogDNA.CogDept.BOSS: body.set_color(Color("a27154ff"))
					CogDNA.CogDept.BOARD: body.set_color(Color("00d8eaff"))
					CogDNA.CogDept.TECH: body.set_color(Color("9445bdff"))
					CogDNA.CogDept.PRESS: body.set_color(Color("d28482ff"))
		else:
			for child in body.skeleton.get_children():
				if child is MeshInstance3D:
					for i in child.mesh.get_surface_count():
						child.get_surface_override_material(i).albedo_color = EXE_COG_COLOR
						child.get_surface_override_material(i).albedo_color.a = 0.8
	head_node = body.head_node

	dna_set = true
	s_dna_set.emit()
	
	drop_shadow.reparent(body.shadow_bone)

func animation_end(_anim):
	set_animation('neutral')


func battle_start():
	department_emblem.hide()
	hp_light.show()
	if BattleService.ongoing_battle is not BattleManager: await BattleService.s_battle_started
	if skelecog:
		if virtual_cog:
			var effect: StatusEffect = load(health_virutal).duplicate(true)
			effect.target = self
			BattleService.ongoing_battle.add_status_effect(effect)
			print("Virtual Cog detected")
		else:
			if dna.cog_name != "Witness Stand-In":
				var effect: StatusEffect = load(health_skele).duplicate(true)
				effect.target = self
				BattleService.ongoing_battle.add_status_effect(effect)
				print("Skelecog detected")
	var overcharged: StatusEffect = load(overcharge).duplicate(true)
	overcharged.target = self
	BattleService.ongoing_battle.add_status_effect(overcharged)
	print("Overcharged")

func update_health_light():
	var health_ratio: float = float(stats.hp) / float(stats.max_hp)
	if body_tween:
		body_tween.kill()
		body_tween = null
		
	if virtual_cog:
		if health_ratio >= 1.5:
			body.set_color(Color("8700ffcc"))
		elif health_ratio >= 1.02:
			body.set_color(Color("00ffffcc"))
		elif health_ratio >= .95:
			body.set_color(Color("00ff00cc"))
		elif health_ratio >= .7:
			body.set_color(Color("ffff00cc"))
		elif health_ratio >= .3:
			body.set_color(Color("ff8000cc"))
		elif health_ratio >= .05:
			body.set_color(Color("ff0000cc"))
		elif health_ratio > 0.0:
			body_tween = create_tween()
			body_tween.set_loops()
			body_tween.tween_callback(body.set_color.bind(Color("ff0000cc")))
			body_tween.tween_interval(0.75)
			body_tween.tween_callback(body.set_color.bind(Color("4d4d4dcc")))
			body_tween.tween_interval(0.1)
		else:
			body_tween = create_tween()
			body_tween.set_loops()
			body_tween.tween_callback(body.set_color.bind(Color("ff0000cc")))
			body_tween.tween_interval(0.25)
			body_tween.tween_callback(body.set_color.bind(Color("4d4d4dcc")))
			body_tween.tween_interval(0.1)

	if light_tween:
		light_tween.kill()
		light_tween = null

	if health_ratio >= 1.5:
		hp_light.set_color(Color(0.529, 0.0, 1.0, 1.0), Color(0.529, 0.0, 1.0, 0.502))
	elif health_ratio >= 1.02:
		hp_light.set_color(Color(0.0, 1.0, 1.0, 1.0), Color(0.251, 1.0, 1.0, 0.502))
	elif health_ratio >= .95:
		hp_light.set_color(Color(0, 1, 0), Color(.25, 1, .25, .5))
	elif health_ratio >= .7:
		hp_light.set_color(Color(1, 1, 0), Color(1, 1, .25, .5))
	elif health_ratio >= .3:
		hp_light.set_color(Color(1, .5, 0), Color(1, .5, .25, .5))
	elif health_ratio >= .05:
		hp_light.set_color(Color(1, 0, 0), Color(1, .25, .25, .5))
	elif health_ratio > 0.0:
		light_tween = create_tween()
		light_tween.set_loops()
		light_tween.tween_callback(hp_light.set_color.bind(Color(1, 0, 0), Color(1, .25, .25, .5)))
		light_tween.tween_interval(0.75)
		light_tween.tween_callback(hp_light.set_color.bind(Color(.3, .3, .3), Color(0, 0, 0, 0)))
		light_tween.tween_interval(0.1)
	else:
		light_tween = create_tween()
		light_tween.set_loops()
		light_tween.tween_callback(hp_light.set_color.bind(Color(1, 0, 0), Color(1, .25, .25, .5)))
		light_tween.tween_interval(0.25)
		light_tween.tween_callback(hp_light.set_color.bind(Color(.3, .3, .3), Color(0, 0, 0, 0)))
		light_tween.tween_interval(0.1)

func set_animation(anim: String):
	if lured and anim == 'neutral':
		set_animation('lured')
		return
	if animator.has_animation(anim):
		skeleton.reset_bone_poses()
		animator.play(anim)
		animator.advance(0.0)
	else:
		push_warning("Invalid cog animation: %s" % anim)

func pause_animator() -> void:
	if animator:
		animator.pause()

func unpause_animator() -> void:
	if animator:
		animator.play()

func animator_seek(pos: float) -> void:
	if animator:
		animator.seek(pos)

func move_to(new_pos: Vector3, speed: float = walk_speed) -> Tween:
	
	var time = new_pos.distance_to(global_position) / speed
	set_animation('walk')
	if global_position.distance_to(new_pos) > 0.5:
		face_position(new_pos)
	var move_tween = create_tween()
	move_tween.tween_property(self, 'global_position', new_pos,time)
	move_tween.finished.connect(
	func():
		move_tween.kill()
		set_animation('neutral')
	)
	return move_tween

func turn_to_face(global_pos : Vector3, time := 3.0) -> Tween:
	var current_rotation := rotation.y
	face_position(global_pos)
	var goal_rotation := rotation.y
	rotation.y = current_rotation
	var rotation_tween := create_tween()
	rotation_tween.tween_callback(set_animation.bind('walk'))
	rotation_tween.tween_property(self, 'rotation:y', goal_rotation, time)
	rotation_tween.tween_callback(set_animation.bind('neutral'))
	return rotation_tween

func get_attack() -> CogAttack:
	if stunned:
		return null
	else:
		if attacks.size() == 0:
			return get_debug_attack()
		
		var attack: CogAttack = attacks.pick_random().duplicate(true)
		attack.user = self
		if attack.damage > 0:
			attack.damage += get_damage_boost()
		if Util.get_player().random_cog_heals and randf() < Util.get_relevant_player_stats().get_luck_weighted_chance(0.05, 0.15, 2.0):
			attack.store_boost_text("Lovely Heal!", Color.HOT_PINK)
			attack.damage = -attack.damage
		# Get the target
		attack.targets = get_targets(attack.target_type)
		
		return attack
		
func get_targets(target_type):
	match target_type:
		BattleAction.ActionTarget.SELF:
			return [self]
		BattleAction.ActionTarget.ALLY:
			var valid_cogs = BattleService.ongoing_battle.cogs.duplicate(true)
			valid_cogs.erase(self)
			if valid_cogs.size() == 0:
				return []
			else:
				return [valid_cogs[randi()%valid_cogs.size()]]
		BattleAction.ActionTarget.ALLIES:
			var valid_cogs = BattleService.ongoing_battle.cogs.duplicate(true)
			valid_cogs.erase(self)
			return valid_cogs
		_:
			return [Util.get_player()]
func get_damage_boost() -> int:
	return level / 2

func lose():
	# Get the lose model
	# (Should refactor this later because I hate looking at it)
	# ^ This never happened lol
	if losing:
		return
	losing = true
	
	if not drop_shadow.get_parent() == self:
		drop_shadow.reparent(self)
	
	var lose_mod: Node3D
	if not skelecog:
		match dna.suit:
			CogDNA.SuitType.SUIT_A:
				lose_mod = load("res://objects/cog/suita/suita_lose.tscn").instantiate()
			CogDNA.SuitType.SUIT_B:
				lose_mod = load("res://objects/cog/suitb/suitb_lose.tscn").instantiate()
			CogDNA.SuitType.SUIT_C:
				lose_mod = load("res://objects/cog/suitc/suitc_lose.tscn").instantiate()
	else:
		match dna.suit:
			CogDNA.SuitType.SUIT_A:
				lose_mod = load("res://objects/cog/suita/skelecog_a_lose.tscn").instantiate()
			CogDNA.SuitType.SUIT_B:
				lose_mod = load("res://objects/cog/suitb/skelecog_b_lose.tscn").instantiate()
			CogDNA.SuitType.SUIT_C:
				lose_mod = load("res://objects/cog/suitc/skelecog_c_lose.tscn").instantiate()
	
	body.hide()
	body_root.add_child(lose_mod)
	lose_mod.set_dna(dna)
	lose_mod.scale = body.scale
	lose_mod.animator.play('lose')
	
	if body.body_color != Color.WHITE:
		lose_mod.set_color(body.body_color)
	
	# Play explosion sound
	await get_tree().create_timer(2.1).timeout
	
	# Particles
	var gear_part: GPUParticles3D = load("res://objects/battle/effects/cog_gears/cog_gears.tscn").instantiate()
	lose_mod.add_child(gear_part)
	gear_part.global_position = department_emblem.global_position
	if should_do_gear_shower():
		gear_part.amount = 6000
		Globals.s_cog_volcano.emit()
	if dna.cog_name == "Duck Shuffler":
		AudioManager.play_sound(load('res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_duckshfl_death.ogg'), -6.0)
	elif dna.cog_name == "Prethinker":
		AudioManager.play_sound(load('res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_prethink_death.ogg'), -6.0)
	elif dna.cog_name == "Desk Jockey":
		AudioManager.play_sound(load('res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_djockey_death.ogg'), -6.0)
	elif dna.cog_name == "Deep Diver":
		AudioManager.play_sound(load('res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_ddiver_death.ogg'), -6.0)
	elif dna.cog_name == "Rainmaker":
		AudioManager.play_sound(load('res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_rainmake_death.ogg'), -6.0)
	elif dna.cog_name == "Gatekeeper":
		AudioManager.play_sound(load('res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_gatekeep_death.ogg'), -6.0)
	elif dna.cog_name == "Witch Hunter":
		AudioManager.play_sound(load('res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_whunter_death.ogg'), -6.0)
	elif dna.cog_name == "Bellringer":
		AudioManager.play_sound(load('res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_bellring_death.ogg'), -6.0)
	elif dna.cog_name == "Multislacker":
		AudioManager.play_sound(load('res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_mslacker_death.ogg'), -6.0)
	elif dna.cog_name == "Mouthpiece":
		AudioManager.play_sound(load('res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_mouthp_death.ogg'), -6.0)
	elif dna.cog_name == "Major Player":
		AudioManager.play_sound(load('res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_mplayer_death.ogg'), -6.0)
	elif dna.cog_name == "Firestarter":
		AudioManager.play_sound(load('res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_fires_death.ogg'), -6.0)
	elif dna.cog_name == "Plutocrat":
		AudioManager.play_sound(load('res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_pcrat_death.ogg'), -6.0)
	elif dna.cog_name == "Charon" or dna.cog_name == "Hydra" or dna.cog_name == "Kerberos" or dna.cog_name == "Nix" or dna.cog_name == "Styx" or dna.cog_name == "Skele-Foreman" or dna.cog_name == "Mint Supervisor" or dna.cog_name == "Head Attorney" or dna.cog_name == "Skele-President":
		AudioManager.play_sound(load('res://audio/sfx/battle/cogs/Skel_Cog_Death.ogg'), -6.0)
	elif dna.cog_name == "Treekiller":
		AudioManager.play_sound(load('res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_treek_death.ogg'), -6.0)
	elif dna.cog_name == "Chainsaw Consultant":
		AudioManager.play_sound(load('res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_chainsaw_death.ogg'), -6.0)
	elif dna.cog_name == "Featherbedder":
		AudioManager.play_sound(load('res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_fbed_death.ogg'), -6.0)
	elif dna.cog_name == "Pacesetter":
		AudioManager.play_sound(load('res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_psetter_death.ogg'), -6.0)
	elif dna.cog_name == "Derrick Man":
		AudioManager.play_sound(load('res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_derrman_death.ogg'), -6.0)
	elif dna.cog_name == "Derrick Hand" and not skelecog:
		AudioManager.play_sound(load('res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_derrhand_death.ogg'), -6.0)
	elif dna.cog_name == "Derrick Hand" and skelecog:
		AudioManager.play_sound(load('res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_derrhand_death_skel.ogg'), -6.0)
	elif dna.cog_name == "Land Acquisition Architect":
		AudioManager.play_sound(load('res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_dlao_death.ogg'), -6.0)
	elif dna.cog_name == "Director of Land Development":
		AudioManager.play_sound(load('res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_dold_death.ogg'), -6.0)	
	elif dna.cog_name == "Public Relations Representative":
		AudioManager.play_sound(load('res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_dopr_death_skel.ogg'), -6.0)
	elif dna.cog_name == "Director Of Public Affairs":
		AudioManager.play_sound(load('res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_dopa_death_skel.ogg'), -6.0)
	elif dna.cog_name == "Redd Heir Wing":
		AudioManager.play_sound(load('res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_redd_death.ogg'), -6.0)
	elif dna.cog_name == "Litigator":
		AudioManager.play_sound(load('res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_lgator_death.ogg'), -6.0)
	elif dna.cog_name == "Stenographer":
		AudioManager.play_sound(load('res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_stenog_death.ogg'), -6.0)
	elif dna.cog_name == "Case Manager":
		AudioManager.play_sound(load('res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_caseman_death.ogg'), -6.0)
	elif dna.cog_name == "Scapegoat":
		AudioManager.play_sound(load('res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_sgoat_death.ogg'), -6.0)
	else:
		if dna.is_female_cog:
			if skelecog:
				AudioManager.play_sound(load('res://audio/sfx/battle/cogs/Skel_Cog_Death_f.ogg'), -6.0)
			else:
				AudioManager.play_sound(load('res://audio/sfx/battle/cogs/Cog_Death_f.ogg'), -6.0)
		else:
			if skelecog:
				AudioManager.play_sound(load('res://audio/sfx/battle/cogs/Skel_Cog_Death.ogg'), -6.0)
			else:
				AudioManager.play_sound(load('res://audio/sfx/battle/cogs/Cog_Death.ogg'), -6.0)	
	await get_tree().create_timer(3.55).timeout
	AudioManager.play_sound(load('res://audio/sfx/battle/cogs/ENC_cogfall_apart.ogg'), -10.0)
	var explosion : AnimatedSprite3D = load('res://models/cogs/misc/explosion/cog_explosion.tscn').instantiate()
	lose_mod.add_child(explosion)
	explosion.global_position = department_emblem.global_position
	explosion.scale = Vector3(15, 15, 15)
	explosion.play('explode')
	await Util.barrier(explosion.animation_finished, 0.5)
	explosion.hide()
	gear_part.emitting = false
	queue_free()

func do_knockback():
	var start_time: float
	#A: 2.4
	#B: 1.9s
	#C: 2.6
	match dna.suit:
		CogDNA.SuitType.SUIT_A:
			start_time = 2.4
		CogDNA.SuitType.SUIT_B:
			start_time = 1.9
		CogDNA.SuitType.SUIT_C:
			start_time = 2.6
	set_animation('slip-forward')
	animator.seek(start_time)
	await animator.animation_finished

# Make the cog say stuff
func speak(phrase: String, want_sfx := true):
	if not dna.can_speak: return
	if dna.cog_name == "Duck Shuffler":
		grunt = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_duckshfl_grunt.ogg")
		murmur = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_duckshfl_murmur.ogg")
		statement = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_duckshfl_statement.ogg")
		question = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_duckshfl_question.ogg")
		question_long = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_duckshfl_question.ogg")
	if dna.cog_name == "Prethinker":
		grunt = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_prethink_grunt.ogg")
		murmur = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_prethink_murmur.ogg")
		statement = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_prethink_statement.ogg")
		question = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_prethink_question.ogg")
		question_long = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_prethink_question.ogg")
	if dna.cog_name == "Desk Jockey":
		grunt = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_djockey_grunt.ogg")
		murmur = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_djockey_murmur.ogg")
		statement = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_djockey_statement.ogg")
		question = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_djockey_question.ogg")
		question_long = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_djockey_question.ogg")
	if dna.cog_name == "Deep Diver":
		grunt = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_ddiver_grunt.ogg")
		murmur = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_ddiver_murmur.ogg")
		statement = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_ddiver_statement.ogg")
		question = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_ddiver_question.ogg")
		question_long = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_ddiver_question.ogg")
	if dna.cog_name == "Rainmaker":
		grunt = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_rainmake_grunt.ogg")
		murmur = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_rainmake_murmur.ogg")
		statement = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_rainmake_statement.ogg")
		question = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_rainmake_question.ogg")
		question_long = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_rainmake_question.ogg")
	if dna.cog_name == "Gatekeeper":
		grunt = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_gatekeep_grunt.ogg")
		murmur = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_gatekeep_murmur.ogg")
		statement = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_gatekeep_statement.ogg")
		question = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_gatekeep_question.ogg")
		question_long = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_gatekeep_question.ogg")
	if dna.cog_name == "Witch Hunter":
		grunt = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_whunter_grunt.ogg")
		murmur = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_whunter_murmur.ogg")
		statement = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_whunter_statement.ogg")
		question = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_whunter_question.ogg")
		question_long = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_whunter_question.ogg")
	if dna.cog_name == "Bellringer":
		grunt = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_bellring_grunt.ogg")
		murmur = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_bellring_murmur.ogg")
		statement = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_bellring_statement.ogg")
		question = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_bellring_question.ogg")
		question_long = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_bellring_question.ogg")
	if dna.cog_name == "Multislacker":
		grunt = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_mslacker_grunt.ogg")
		murmur = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_mslacker_murmur.ogg")
		statement = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_mslacker_statement.ogg")
		question = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_mslacker_question.ogg")
		question_long = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_mslacker_question.ogg")
	if dna.cog_name == "Mouthpiece":
		grunt = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_mouthp_grunt.ogg")
		murmur = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_mouthp_murmur.ogg")
		statement = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_mouthp_statement.ogg")
		question = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_mouthp_question.ogg")
		question_long = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_mouthp_question.ogg")
	if dna.cog_name == "Major Player":
		grunt = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_mplayer_grunt.ogg")
		murmur = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_mplayer_murmur.ogg")
		statement = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_mplayer_statement.ogg")
		question = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_mplayer_question.ogg")
		question_long = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_mplayer_question.ogg")
	if dna.cog_name == "Firestarter":
		grunt = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_fires_grunt.ogg")
		murmur = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_fires_murmur.ogg")
		statement = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_fires_statement.ogg")
		question = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_fires_question.ogg")
		question_long = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_fires_question.ogg")
	if dna.cog_name == "Plutocrat":
		grunt = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_pcrat_grunt.ogg")
		murmur = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_pcrat_murmur.ogg")
		statement = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_pcrat_statement.ogg")
		question = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_pcrat_question.ogg")
		question_long = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_pcrat_question.ogg")
	if dna.cog_name == "Charon" or dna.cog_name == "Hydra" or dna.cog_name == "Kerberos" or dna.cog_name == "Nix" or dna.cog_name == "Styx" or dna.cog_name == "Skele-Foreman" or dna.cog_name == "Mint Supervisor" or dna.cog_name == "Head Attorney" or dna.cog_name == "Skele-President":
		grunt = SKELE_GRUNT
		murmur = SKELE_MURMUR
		statement = SKELE_STATEMENT
		question = SKELE_QUESTION
		question_long = SKELE_QUESTION
	if dna.cog_name == "Treekiller":
		grunt = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_treek_grunt.ogg")
		murmur = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_treek_murmur.ogg")
		statement = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_treek_statement.ogg")
		question = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_treek_question.ogg")
		question_long = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_treek_question.ogg")
	if dna.cog_name == "Chainsaw Consultant":
		grunt = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_chainsaw_grunt.ogg")
		murmur = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_chainsaw_murmur.ogg")
		statement = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_chainsaw_statement.ogg")
		question = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_chainsaw_question.ogg")
		question_long = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_chainsaw_question.ogg")
	if dna.cog_name == "Featherbedder":
		grunt = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_fbed_grunt.ogg")
		murmur = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_fbed_murmur.ogg")
		statement = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_fbed_statement.ogg")
		question = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_fbed_question.ogg")
		question_long = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_fbed_question.ogg")
	if dna.cog_name == "Pacesetter":
		grunt = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_psetter_grunt.ogg")
		murmur = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_psetter_murmur.ogg")
		statement = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_psetter_statement.ogg")
		question = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_psetter_question.ogg")
		question_long = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_psetter_question.ogg")
	if dna.cog_name == "Derrick Man":
		grunt = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_derrman_grunt.ogg")
		murmur = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_derrman_murmur.ogg")
		statement = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_derrman_statement.ogg")
		question = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_derrman_question.ogg")
		question_long = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_derrman_question.ogg")
	if dna.cog_name == "Derrick Hand" and not skelecog:
		grunt = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_derrhand_grunt.ogg")
		murmur = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_derrhand_murmur.ogg")
		statement = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_derrhand_statement.ogg")
		question = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_derrhand_question.ogg")
		question_long = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_derrhand_question.ogg")
	if dna.cog_name == "Derrick Hand" and skelecog:
		grunt = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_derrhand_grunt_skel.ogg")
		murmur = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_derrhand_murmur_skel.ogg")
		statement = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_derrhand_statement_skel.ogg")
		question = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_derrhand_question_skel.ogg")
		question_long = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_derrhand_question_skel.ogg")
	if dna.cog_name == "Land Acquisition Architect":
		grunt = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_dlao_grunt.ogg")
		murmur = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_dlao_murmur.ogg")
		statement = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_dlao_statement.ogg")
		question = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_dlao_question.ogg")
		question_long = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_dlao_question.ogg")
	if dna.cog_name == "Director of Land Development":
		grunt = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_dold_grunt.ogg")
		murmur = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_dold_murmur.ogg")
		statement = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_dold_statement.ogg")
		question = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_dold_question.ogg")
		question_long = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_dold_question.ogg")
	if dna.cog_name == "Public Relations Representative":
		grunt = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_dopr_grunt_skel.ogg")
		murmur = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_dopr_murmur_skel.ogg")
		statement = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_dopr_statement_skel.ogg")
		question = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_dopr_question_skel.ogg")
		question_long = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_dopr_question_skel.ogg")
	if dna.cog_name == "Director Of Public Affairs":
		grunt = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_dopa_grunt_skel.ogg")
		murmur = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_dopa_murmur_skel.ogg")
		statement = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_dopa_statement_skel.ogg")
		question = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_dopa_question_skel.ogg")
		question_long = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_dopa_question_skel.ogg")
	if dna.cog_name == "Redd Heir Wing":
		grunt = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_redd_grunt.ogg")
		murmur = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_redd_murmur.ogg")
		statement = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_redd_statement.ogg")
		question = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_redd_question.ogg")
		question_long = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_redd_question.ogg")
	if dna.cog_name == "Litigator":
		grunt = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_lgator_grunt.ogg")
		murmur = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_lgator_murmur.ogg")
		statement = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_lgator_statement.ogg")
		question = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_lgator_question.ogg")
		question_long = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_lgator_question.ogg")
	if dna.cog_name == "Stenographer":
		grunt = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_stenog_grunt.ogg")
		murmur = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_stenog_murmur.ogg")
		statement = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_stenog_statement.ogg")
		question = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_stenog_question.ogg")
		question_long = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_stenog_question.ogg")
	if dna.cog_name == "Case Manager":
		grunt = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_caseman_grunt.ogg")
		murmur = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_caseman_murmur.ogg")
		statement = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_caseman_statement.ogg")
		question = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_caseman_question.ogg")
		question_long = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_caseman_question.ogg")
	if dna.cog_name == "Scapegoat":
		grunt = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_sgoat_grunt.ogg")
		murmur = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_sgoat_murmur.ogg")
		statement = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_sgoat_statement.ogg")
		question = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_sgoat_question.ogg")
		question_long = preload("res://audio/sfx/battle/cogs/special_cogs/ttcc_ene_sgoat_question.ogg")
	# Check for existing speech bubble and remove it
	for child in body.nametag_node.get_children():
		if child is SpeechBubble and not child.is_queued_for_deletion():
			child.finished.emit()
	
	# If phrase is '.', it's just meant to clear any speech bubble
	if phrase == ".":
		return
	
	# Create a speech bubble with the cog font
	var bubble: SpeechBubble = load('res://objects/misc/speech_bubble/speech_bubble.tscn').instantiate()
	bubble.target = body.nametag_node.cog_nametag.chat_node
	body.nametag_node.add_child(bubble)
	bubble.set_font(load('res://fonts/vtRemingtonPortable.ttf'))
	
	# Hide the nametag temporarily
	body.nametag.hide()
	
	bubble.set_text(phrase)

	if want_sfx:
		# Play speech sfx
		# Figure out the appropriate sound effect
		if phrase.contains("!"):
			sfx.stream = grunt
		elif phrase.contains("?"):
			if phrase.length() > 30 and not skelecog: sfx.stream = question_long
			else: sfx.stream = question
		elif phrase.length() > 60:
			sfx.stream = murmur
		else:
			sfx.stream = statement
		
		if is_inside_tree():
			sfx.play()
	
	await bubble.finished
	body.nametag.show()

func fly_in(y_from := 20.0, y_to := 0.0) -> void:
	# Ready the propeller
	var propeller := PROP_PROPELLER.instantiate()
	body.head_bone.add_child(propeller)
	propeller.position = Vector3(0, -0.4, 0.65)
	propeller.rotation_degrees.x = 90
	var prop_animator : AnimationPlayer = propeller.get_node('AnimationPlayer')
	
	# Create the tween
	var fly_tween := create_tween()
	fly_tween.tween_callback(AudioManager.play_sound.bind(SFX_FLY_IN))
	fly_tween.tween_callback(set_animation.bind('landing'))
	fly_tween.tween_callback(animator.set_speed_scale.bind(0.0))
	fly_tween.tween_property(body,'position:y',y_from, 0.0)
	fly_tween.tween_property(body,'position:y',y_to, 3.5)
	fly_tween.tween_callback(animator.set_speed_scale.bind(1.0))
	fly_tween.tween_callback(prop_animator.play.bind('retract'))
	fly_tween.tween_interval(3.0)
	fly_tween.finished.connect(
	func():
		fly_tween.kill()
		propeller.queue_free()
	)

func fly_out(y_to := 20.0) -> void:
	# Ready the propeller
	var propeller := PROP_PROPELLER.instantiate()
	body.head_bone.add_child(propeller)
	propeller.scale *= 120.0
	propeller.position.y += 80.0
	var prop_animator: AnimationPlayer = propeller.get_node('AnimationPlayer')
	
	# Create the tween
	var fly_tween := create_tween()
	fly_tween.tween_callback(AudioManager.play_sound.bind(SFX_FLY_OUT))
	fly_tween.tween_callback(prop_animator.play_backwards.bind('retract'))
	fly_tween.tween_callback(animator.play_backwards.bind('landing'))
	fly_tween.tween_interval(2.25)
	fly_tween.tween_property(body, 'position:y', y_to, 3.5)
	fly_tween.parallel().tween_callback(pause_animator).set_delay(1.5)
	fly_tween.finished.connect(
	func():
		fly_tween.kill()
		propeller.queue_free()
	)

func explode() -> void:
	body.hide()
	AudioManager.play_sound(load('res://audio/sfx/battle/cogs/ENC_cogfall_apart.ogg'))
	var explosion : AnimatedSprite3D = load('res://models/cogs/misc/explosion/cog_explosion.tscn').instantiate()
	explosion.billboard = BaseMaterial3D.BillboardMode.BILLBOARD_FIXED_Y
	add_child(explosion)
	explosion.global_position = department_emblem.global_position
	explosion.scale = Vector3(15, 15, 15)
	explosion.play('explode')
	await Util.barrier(explosion.animation_finished, 0.5)
	explosion.hide()
	queue_free()

func should_do_gear_shower() -> bool:
	# No pity for you if you've already gotten it :)
	if SaveFileService.is_achievement_unlocked(ProgressFile.GameAchievement.EASTER_EGG_GEAR):
		return randi() % 5000 == 0
	# Every Cog is worth 0.05 pity
	var pity := floori(SaveFileService.progress_file.total_cogs_defeated * 0.05)
	return randi() % maxi(5000 - pity, 1) == 0

## Global functions
static func get_department_emblem(dept: CogDNA.CogDept) -> Texture2D:
	return load("res://models/cogs/misc/hp_light/" + Cog.get_department_name(dept) + ".png")

static func get_department_name(dept: CogDNA.CogDept) -> String:
	return CogDNA.CogDept.keys()[int(dept)].to_lower()
