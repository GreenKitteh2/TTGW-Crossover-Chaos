extends BattleStartMovie
class_name AuditorBossIntro

var openers := [
	"The C.F.O. is expecting EXACT change, so don't mess up.",
	"Make sure your timesheet is on my desk by the end of the day.",
	"I want every coin organized by weight, size, and value.",
	"Every coin should be freshly shined before your shift is up.",
	"Any missing assets are coming out of your paycheck.",
]

const INTRO_MUSIC := preload("res://audio/music/ttr_s_ara_chq_facilityBossCutscene.ogg")

var directory: Node3D
var Mint_Auditor: Cog

func _skip() -> void:
	super()
	await BattleService.s_battle_started
	battle_node.focus_character(battle_node)

func play() -> Tween:
	
	var cog1 : Cog = battle_node.cogs[1]
	var cog2 : Cog = battle_node.cogs[2]
	var cog3 : Cog = battle_node.cogs[3]
	
	## MOVIE START
	movie = create_tween()
	directory = battle_node.get_parent()
	AudioManager.set_music(INTRO_MUSIC)
	
	movie.tween_callback(set_camera_angle.bind('FirstCam'))
	movie.tween_interval(0.5)
	movie.tween_callback(focus_cog.speak.bind(openers[RandomService.randi_channel('true_random') % openers.size()]))
	movie.set_trans(Tween.TRANS_QUAD)
	movie.parallel().tween_property(battle_node.battle_cam,'global_transform',get_camera_angle('SecondCam'),6)
	movie.parallel().tween_callback(focus_cog.set_animation.bind('walk')).set_delay(1.0)
	movie.parallel().tween_property(focus_cog,'rotation_degrees:y',0.0,2.0).set_delay(1.0)
	movie.parallel().tween_callback(focus_cog.set_animation.bind('neutral')) .set_delay(3.0)
	movie.parallel().tween_callback(focus_cog.speak.bind("It looks like our security has been compromised.")).set_delay(3.0)
	movie.parallel().tween_callback(cog1.set_animation.bind('walk')).set_delay(4.0)
	movie.parallel().tween_callback(cog2.set_animation.bind('walk')).set_delay(4.0)
	movie.parallel().tween_callback(cog3.set_animation.bind('walk')).set_delay(4.0)
	movie.parallel().tween_property(cog1,'rotation_degrees:y',0.0,2.0).set_delay(4.0)
	movie.parallel().tween_property(cog2,'rotation_degrees:y',0.0,2.0).set_delay(4.0)
	movie.parallel().tween_property(cog3,'rotation_degrees:y',0.0,2.0).set_delay(4.0)
	movie.parallel().tween_callback(cog1.set_animation.bind('neutral')).set_delay(6.0)
	movie.parallel().tween_callback(cog2.set_animation.bind('neutral')).set_delay(6.0)
	movie.parallel().tween_callback(cog3.set_animation.bind('neutral')).set_delay(6.0)
	movie.tween_interval(2.0)
	movie.tween_callback(focus_cog.set_animation.bind('finger-wag')) 
	movie.tween_callback(focus_cog.speak.bind("You may have gotten this far, but the market is on MY side now.."))
	movie.tween_interval(4.0)
	movie.tween_property(battle_node.battle_cam,'global_transform',get_camera_angle('ThirdCam'),4)
	movie.tween_callback(focus_cog.speak.bind("Time is money, Toon. Don't waste mine."))
	movie.tween_interval(4.0)
	
	# Start the music
	movie.tween_callback(start_music)
	movie.tween_callback(AudioManager.music_player.set_volume_db.bind(0.0))
	return movie

func set_camera_angle(angle : String) -> void:
	battle_node.battle_cam.global_transform = get_camera_angle(angle)

func get_char_position(pos : String) -> Vector3:
	return directory.get_char_position(pos)

func get_camera_angle(angle : String) -> Transform3D:
	return directory.get_camera_angle(angle)
