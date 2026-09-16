extends Node3D

var manager: BattleManager = null
@onready var mint_auditor : Cog = $BattleNode/MintAuditorCog
const NO_MARKET_MUSIC := preload("res://audio/music/ttr_s_ara_chq_facilityBossNoMarket.ogg")

func _ready() -> void:
	await Task.delay(0.25)
	manager = await BattleService.s_battle_started
	manager.s_participant_will_die.connect(someone_died.bind(manager))

func someone_died(who : Node3D, manager : BattleManager) -> void:
	if not who == mint_auditor:
		return
	
	# mint auditor has died lol
	AudioManager.set_music(NO_MARKET_MUSIC)
	
func get_camera_angle(angle : String) -> Transform3D:
	return $CameraAngles.find_child(angle).global_transform
	
func get_char_position(pos : String) -> Vector3:
	return $CharPositions.find_child(pos).global_position
