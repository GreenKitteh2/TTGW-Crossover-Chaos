extends BattleStartMovie
class_name ClerkBossIntro

var openers := [
	"I am the Clerk!",
	"I'm the law of the land.",
	"Even the law trembles at my sight.",
	"I make the rules here, and you all lose.",
	"I think it's time for a trial by fire.",
	"The jury has already decided your fate.",
	"I'll throw the book at you, legally speaking.",
	"You're outside your jurisdiction.",
]

const INTRO_MUSIC := preload("res://audio/music/ttr_s_ara_lhq_facilityBossCutscene.ogg")

var directory: Node3D
var Office_Clerk: Cog

func _skip() -> void:
	super()
	await BattleService.s_battle_started
	battle_node.focus_character(battle_node)

func play() -> Tween:
	
	var cog1 : Cog = battle_node.cogs[0]
	var cog2 : Cog = battle_node.cogs[2]
	var cog3 : Cog = battle_node.cogs[3]
	var player := Util.get_player()
	
	## MOVIE START
	movie = create_tween()
	directory = battle_node.get_parent()
	AudioManager.set_music(INTRO_MUSIC)
	
	movie.tween_callback(set_camera_angle.bind('FirstCam'))
	movie.tween_callback(focus_cog.speak.bind("Squabbling like that could only mean one thing around here..."))
	movie.set_trans(Tween.TRANS_QUAD)
	movie.parallel().tween_property(battle_node.battle_cam,'global_transform',get_camera_angle('SecondCam'),2).set_delay(1.0)
	movie.set_trans(Tween.TRANS_LINEAR)
	movie.tween_interval(3.0)
	movie.tween_callback(focus_cog.speak.bind("."))
	movie.tween_callback(set_camera_angle.bind('ThirdCam'))
	movie.tween_interval(1.0) 
	movie.tween_callback(focus_cog.speak.bind("Toons."))
	movie.tween_interval(2.5) 
	movie.tween_callback(set_camera_angle.bind('SecondCam'))
	movie.tween_callback(focus_cog.set_animation.bind('walk'))
	movie.tween_callback(focus_cog.speak.bind("You!"))
	movie.tween_property(focus_cog,'rotation_degrees:y',0.0,2.0)	
	movie.set_trans(Tween.TRANS_QUAD)
	movie.parallel().tween_property(battle_node.battle_cam,'global_transform',get_camera_angle('FirstCam'),2)
	movie.set_trans(Tween.TRANS_LINEAR)
	movie.tween_callback(focus_cog.set_animation.bind('neutral')) 
	movie.tween_callback(focus_cog.speak.bind("How did your incessant silliness bypass our tightened security?"))
	movie.tween_callback(cog1.fly_in)
	movie.tween_callback(cog2.fly_in)
	movie.tween_callback(cog3.fly_in)
	movie.tween_callback(cog1.show)
	movie.tween_callback(cog2.show)
	movie.tween_callback(cog3.show)
	movie.tween_interval(3.0) 
	movie.tween_callback(focus_cog.set_animation.bind('speak'))
	movie.tween_callback(focus_cog.speak.bind("Regardless, your insolence ends here, Toon."))
	movie.tween_interval(3.0) 
	movie.tween_callback(set_camera_angle.bind('FourthCam'))
	movie.tween_callback(focus_cog.speak.bind(openers[RandomService.randi_channel('true_random') % openers.size()]))
	movie.tween_interval(5.5) 
	
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
