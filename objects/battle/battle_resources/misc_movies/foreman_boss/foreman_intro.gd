extends BattleStartMovie
class_name ForemanBossIntro

const INTRO_MUSIC := preload("res://audio/music/ttr_s_ara_shq_facilityBossCutscene.ogg")
var SFX := preload("res://audio/sfx/battle/cogs/attacks/special/contractlimit_audio.ogg")

var directory: Node3D
var Factory_Foreman: Cog

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
	movie.set_trans(Tween.TRANS_QUAD)
	movie.tween_property(battle_node.battle_cam,'global_transform',get_camera_angle('SecondCam'),6)
	movie.tween_callback(focus_cog.speak.bind("Toons..."))
	movie.tween_interval(2.0)
	movie.set_trans(Tween.TRANS_LINEAR)
	movie.tween_callback(set_camera_angle.bind('ThirdCam'))
	movie.set_trans(Tween.TRANS_QUAD)
	movie.tween_property(battle_node.battle_cam,'global_transform',get_camera_angle('FourthCam'),7)
	movie.parallel().tween_callback(focus_cog.speak.bind("This intrusion will certainly affect our timetable."))
	movie.parallel().tween_callback(focus_cog.set_animation.bind('times-up')).set_delay(3.0)
	movie.parallel().tween_callback(AudioManager.play_sound.bind(SFX)).set_delay(3.0)
	movie.parallel().tween_callback(focus_cog.speak.bind("To meet our quota, we must run this factory like clockwork.")).set_delay(3.0)
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
	movie.set_trans(Tween.TRANS_LINEAR)
	movie.tween_callback(set_camera_angle.bind('FifthCam'))
	movie.tween_callback(focus_cog.set_animation.bind('magic1')) 
	movie.tween_callback(focus_cog.speak.bind("Fortunately, a well-protected Cog can resolve this setback."))
	movie.tween_interval(5.0)
	
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
