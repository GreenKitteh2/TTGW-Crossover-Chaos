extends BattleStartMovie
class_name WSIIntro

const SFX_SPARK := preload("res://audio/sfx/battle/cogs/misc/LB_sparks_1.ogg")
const INTRO_MUSIC := preload("res://audio/music/paranormal_cutscene.ogg")

var directory: Node3D
var Witness_Stand_In: Cog
var player: Player

func _skip() -> void:
	super()
	focus_cog.position = Vector3.ZERO
	player.global_position = battle_node.player_pos
	player.set_animation('neutral')
	camera.look_at(battle_node.global_position)
	await BattleService.s_battle_started
	battle_node.focus_character(battle_node)

func play() -> Tween:
	# Get our dependencies
	directory = battle_node.get_parent()
	player = Util.get_player()
	AudioManager.set_music(INTRO_MUSIC)
	
	movie = create_tween()
	
	# Player walks in
	movie.tween_callback(set_camera_angle.bind('FirstCam'))
	movie.tween_callback(player.set_animation.bind('walk'))
	movie.tween_callback(player.face_position.bind(get_char_position('WalkInPos')))
	movie.tween_property(player, 'global_position', get_char_position('WalkInPos'), 5.0)
	movie.set_trans(Tween.TRANS_QUAD)
	movie.parallel().tween_property(battle_node.battle_cam,'global_transform',get_camera_angle('SecondCam'),6).set_delay(1.0)
	movie.set_trans(Tween.TRANS_LINEAR)
	movie.parallel().tween_callback(player.set_animation.bind('neutral')).set_delay(5.0)
	movie.parallel().tween_callback(AudioManager.play_sound.bind(SFX_SPARK)).set_delay(4.0)
	focus_cog.body.set_color(Color('9bafff',0.8))
	movie.parallel().tween_callback(focus_cog.speak.bind("At last...We meet again Toon...")).set_delay(4.0)
	movie.parallel().tween_callback(focus_cog.show).set_delay(4.0)
	movie.parallel().tween_callback(focus_cog.set_animation.bind('drop')).set_delay(4.0)
	movie.parallel().tween_callback(focus_cog.animator_seek.bind(3.0)).set_delay(4.0)
	movie.tween_interval(2.0)
	movie.tween_callback(set_camera_angle.bind('ThirdCam'))
	movie.tween_callback(focus_cog.speak.bind("I've been expecting you here, on your way on saving a toon."))
	movie.tween_interval(4.0)
	movie.tween_callback(focus_cog.speak.bind("You see, before my death..."))
	movie.tween_interval(3.0) 
	movie.tween_callback(focus_cog.speak.bind("I taught a young Miss Whistleblower of my tactics."))
	movie.tween_interval(3.0) 
	movie.tween_callback(focus_cog.set_animation.bind('speak'))
	movie.tween_callback(focus_cog.speak.bind("And right after my tragic death, she made a promise to avange my death, therefore she herself became a director."))
	movie.tween_interval(5.0)
	movie.tween_callback(focus_cog.speak.bind("If only I was there to see her develop her glory to be an apprentice, but you toons have to ruin it!"))
	movie.tween_interval(5.0)
	movie.tween_callback(focus_cog.speak.bind("And I haven't forgot about your resistance."))
	movie.tween_interval(3.0)
	movie.tween_callback(focus_cog.speak.bind("Not only you destroyed my family, but after my death, the entire Lawbot HQ was in complete disarray!"))
	movie.tween_interval(5.0)
	movie.tween_callback(focus_cog.speak.bind("But unfortunately for you, I've returned for revenge..."))
	movie.tween_interval(3.0)
	movie.tween_callback(focus_cog.speak.bind("With my army of ghastly Cogs..."))
	movie.tween_interval(2.0)
	movie.tween_callback(focus_cog.set_animation.bind('buffed'))
	movie.tween_callback(focus_cog.speak.bind("I will sadden the heart of Toontown and restore Cogs Inc. to it's former glory!"))
	movie.tween_interval(5.0)
	movie.tween_callback(focus_cog.set_animation.bind('finger-wag'))
	movie.tween_callback(focus_cog.speak.bind("And that Unfinished business will begin by finishing YOU!"))
	movie.set_trans(Tween.TRANS_QUAD)
	movie.parallel().tween_property(battle_node.battle_cam,'global_transform',get_camera_angle('FourthCam'),3)
	movie.set_trans(Tween.TRANS_LINEAR)
	movie.tween_interval(4.0)
	movie.tween_callback(focus_cog.set_animation.bind('effort'))
	movie.tween_callback(focus_cog.speak.bind("Make your last statements Toon..."))
	movie.tween_interval(2.0)
	movie.tween_callback(focus_cog.speak.bind("Because the ruling will not be pretty, En garde!"))
	movie.tween_interval(5.0)
	movie.tween_callback(start_music) 
	return movie

func set_camera_angle(angle : String) -> void:
	battle_node.battle_cam.global_transform = get_camera_angle(angle)

func get_char_position(pos : String) -> Vector3:
	return directory.get_char_position(pos)

func get_camera_angle(angle : String) -> Transform3D:
	return directory.get_camera_angle(angle)
