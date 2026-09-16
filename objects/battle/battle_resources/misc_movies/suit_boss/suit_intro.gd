extends BattleStartMovie
class_name SuitBossIntro

var directory: Node3D

func _skip() -> void:
	super()
	await BattleService.s_battle_started
	battle_node.focus_character(battle_node)

func play() -> Tween:
	
	# Get all cog actors for cutscene
	var suita : Cog = battle_node.cogs[0]
	var suitb : Cog = battle_node.cogs[1]
	var suitc : Cog = battle_node.cogs[2]
	
	## MOVIE START
	movie = create_tween()
	directory = battle_node.get_parent()
		
	movie.tween_callback(set_camera_angle.bind('FirstCam'))
	movie.tween_callback(suitb.speak.bind("Guys, relax, I promise I can fix this."))
	movie.tween_interval(5.0) 
	movie.tween_callback(suitc.set_animation.bind('halt'))
	movie.tween_callback(suitc.speak.bind("Fix this?! We look like monsters!"))
	movie.tween_interval(5.0) 
	movie.tween_callback(suita.speak.bind("Seriously, what if the Boss finds out about this operation!"))
	movie.tween_interval(5.0) 
	movie.tween_callback(suita.set_animation.bind('speak'))
	movie.tween_callback(suita.speak.bind("Not only it going to get shut down, we're also FIRED!"))
	movie.tween_interval(5.0) 
	movie.tween_callback(suitb.speak.bind("Look as long as nobody says anything about-"))
	movie.tween_callback(suita.set_animation.bind('walk'))
	movie.tween_property(suita,'rotation_degrees:y',0.0,2.0)
	movie.tween_callback(suita.set_animation.bind('neutral'))
	movie.tween_callback(suita.speak.bind("Didn't mean to cut you off but, is this Toon supposed to be here?"))
	movie.tween_interval(5.0) 
	movie.tween_callback(suitc.speak.bind("What?"))
	movie.tween_callback(suitc.set_animation.bind('walk'))
	movie.tween_callback(set_camera_angle.bind('SecondCam'))
	movie.tween_property(suitc,'rotation_degrees:y',0.0,2.0)
	movie.set_trans(Tween.TRANS_QUAD)
	movie.parallel().tween_property(battle_node.battle_cam,'global_transform',get_camera_angle('SecondCam'),2)
	movie.set_trans(Tween.TRANS_LINEAR)
	movie.tween_callback(suitc.set_animation.bind('neutral')) 
	movie.tween_callback(suitc.speak.bind("Ah oh-"))
	movie.tween_interval(2.0) 
	movie.tween_callback(suita.speak.bind("Listen, I know this may look weird but this place is off limits for anyone."))
	movie.tween_interval(5.0) 
	movie.tween_callback(suita.speak.bind("Just don't tell anyone about this, okay?"))
	movie.tween_interval(5.0) 
	movie.tween_callback(suitc.speak.bind("Wait why are we telling a toon this? would they even care what happens?"))
	movie.tween_interval(5.0) 
	movie.tween_callback(suita.speak.bind("Yea you're right I didn't think that."))
	movie.tween_interval(5.0) 
	movie.tween_callback(suita.speak.bind("."))
	movie.tween_callback(suitc.speak.bind("."))
	movie.tween_callback(suitb.speak.bind("Well why are we just standing here? let's teach this Toon a lesson!"))
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
