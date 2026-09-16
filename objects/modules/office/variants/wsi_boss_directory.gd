extends Node3D

@onready var cog: Cog = %Witness_Stand_In
var manager: BattleManager = null

func _ready() -> void:
	await Task.delay(0.25)
	manager = await BattleService.s_battle_started

	# Connect the round start signal to the method
	manager.s_round_started.connect(on_round_start.bind(manager))

func get_camera_angle(angle : String) -> Transform3D:
	return $CameraAngles.find_child(angle).global_transform
	
func get_char_position(pos : String) -> Vector3:
	return $CharPositions.find_child(pos).global_position

## Insert the boss's relevant actions at the beginning of each round
func on_round_start(_actions: Array[BattleAction], _manager: BattleManager) -> void:
	if (not is_instance_valid(cog)) or cog.stats.hp <= 0:
		return

	# var attack: CogAttack
	# if manager.current_round % 2 == 1 and manager.cogs.size() < 2:
		# Insert reboot
		# attack = load("res://objects/battle/battle_resources/misc_movies/witness_boss/wsi_resurrect.tres").duplicate()
		# attack.user = cog
		# manager.round_end_actions.append(attack)
