extends BattleStartMovie
class_name ClubBossIntro

const INTRO_MUSIC := preload("res://audio/music/ttr_s_ara_bhq_facilityBossCutscene.ogg")

var directory: Node3D
var Club_President: Cog

func _skip() -> void:
	super()
	await BattleService.s_battle_started
	battle_node.focus_character(battle_node)

func play() -> Tween:
	
	var cog : Cog = battle_node.cogs[0]
	
	## MOVIE START
	movie = create_tween()
	directory = battle_node.get_parent()
	AudioManager.set_music(INTRO_MUSIC)
	
	movie.tween_callback(set_camera_angle.bind('FirstCam'))
	movie.tween_callback(focus_cog.speak.bind("As your lovely Club President, You are now part of the Country Club!"))
	movie.set_trans(Tween.TRANS_QUAD)
	movie.parallel().tween_property(battle_node.battle_cam,'global_transform',get_camera_angle('SecondCam'),2).set_delay(1.0)
	movie.set_trans(Tween.TRANS_LINEAR)
	movie.tween_interval(3.0)
	movie.tween_callback(set_camera_angle.bind('ThirdCam')) 
	movie.tween_callback(cog.speak.bind("Hate to storm the parade but, there is a Toon behind you."))
	movie.tween_interval(4.0) 
	movie.tween_callback(set_camera_angle.bind('FourthCam'))
	movie.tween_callback(focus_cog.set_animation.bind('walk'))
	movie.tween_callback(cog.speak.bind("."))
	movie.tween_callback(focus_cog.speak.bind("Hm?"))
	movie.tween_property(focus_cog,'rotation_degrees:y',0.0,2.0)	
	movie.tween_callback(focus_cog.set_animation.bind('neutral')) 
	movie.tween_callback(focus_cog.speak.bind("Well well well, seems like someone came to the club uninvited."))
	movie.tween_interval(3.0) 
	movie.tween_callback(focus_cog.speak.bind("I hate to burst your bubble but you are not suitiable for this Country Club."))
	movie.tween_interval(3.0) 
	movie.set_trans(Tween.TRANS_QUAD)
	movie.parallel().tween_property(battle_node.battle_cam,'global_transform',get_camera_angle('SecondCam'),2)
	movie.set_trans(Tween.TRANS_LINEAR)
	movie.tween_callback(focus_cog.set_animation.bind('speak'))
	movie.tween_callback(focus_cog.speak.bind("You'll regret entering this Country Club..."))
	movie.tween_interval(3.0) 
	movie.tween_callback(focus_cog.speak.bind("MY Country Club."))
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
