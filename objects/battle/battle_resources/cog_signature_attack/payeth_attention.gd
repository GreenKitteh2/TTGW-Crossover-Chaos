extends CogAttack
const COG := preload('res://objects/cog/cog.tscn')
const SFX_STOMP := preload("res://audio/sfx/misc/ENC_cogjump_to_side.ogg")

const PHRASES := [
	"Art thou trying to insulteth me? Awaken, fool!",
	"How dareth thee slack in my presence!",
	"Thou shall awaken at once!",
	"MYou there! Payeth attention! I commandeth thee!"
]

var response_lines: Array[String] = [
	"Uh...Huh? What happened?",
	"Ah! Sorry sorry!",
	"Sorry about that...I'll focus."
]

func action() -> void:
	if len(manager.cogs) <= 1:
		return
	var cog: Cog = user
	var target : Cog = targets[0]
	
	var movie := manager.create_tween()
	
	# Focus user
	if target.lured:
		manager.show_action_name("Payeth Attention!", "Unlures a Cog!")
		var phrase_choice: String = RandomService.array_pick_random('true_random', PHRASES)
		movie.tween_callback(cog.speak.bind(phrase_choice))
		battle_node.focus_cogs()
		battle_node.battle_cam.position.z += 3.0
		movie.tween_callback(cog.set_animation.bind('stomp'))
		movie.tween_callback(AudioManager.play_sound.bind(SFX_STOMP))
		movie.tween_callback(cog.face_position.bind(target.global_position))
		movie.tween_interval(1.5)
	
		# Focus target
		var dialogue_choice: String = RandomService.array_pick_random('true_random', response_lines)
		movie.tween_callback(target.speak.bind(dialogue_choice))
		movie.tween_callback(target.set_animation.bind('slip-forward'))
		movie.tween_interval(3.0)
		movie.tween_callback(target.set_animation.bind('walk'))
		movie.tween_property(target.get_node('Body'),'position:z',0,1.0)
		movie.tween_callback(target.set_animation.bind('neutral'))
		manager.force_unlure(target)
		movie.tween_interval(3.0)
		
		# Cleanup
		await movie.finished
		movie.kill()
	else:
		# Cleanup
		movie.kill()
