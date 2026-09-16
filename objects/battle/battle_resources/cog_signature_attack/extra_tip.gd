extends CogAttack
const COG := preload('res://objects/cog/cog.tscn')

const PHRASES := [
	"You've done great work today. Here's an extra tip."
]
var response_lines: Array[String] = [
	"Thank you.",
	"Much obliged.",
	"Needed that.",
	"How nice of you.",
]

const CAN := preload("res://models/props/cog_props/bounce_check/bouncecheck.glb")
const CanPos = Vector3(0.735, 0.661, -0.653)
const CanRot = Vector3(-2.3, 46.8, 58.2)

const SFX_OIL_CAN := preload("res://audio/sfx/battle/cogs/attacks/SA_refinement.ogg")
const SFX_HEAL := preload("res://audio/sfx/items/laff_boost_pickup.ogg")

func action() -> void:
	if len(manager.cogs) <= 1:
		return
	var cog: Cog = user
	var target : Cog = targets[0]
		
	var heal_amount := -(cog.stats.max_hp / 4)
	
	var movie := manager.create_tween()
	
	# Focus user
	manager.show_action_name("Extra Tip!", "")
	battle_node.focus_character(cog)
	var oil_can := CAN.instantiate()
	movie.tween_callback(cog.body.right_hand_bone.add_child.bind(oil_can))
	oil_can.position = CanPos
	oil_can.rotation_degrees = CanRot
	
	var phrase_choice: String = RandomService.array_pick_random('true_random', PHRASES)
	movie.tween_callback(cog.speak.bind(phrase_choice))
	user.set_animation('throw-paper')
	movie.tween_interval(2.4)
	movie.tween_callback(func(): AudioManager.play_sound(load("res://audio/sfx/battle/cogs/attacks/SA_extra_tip.ogg")))
	movie.tween_callback(oil_can.queue_free.bind())
	movie.tween_interval(3.0)
	
	# Focus target
	var dialogue_choice: String = RandomService.array_pick_random('true_random', response_lines)
	movie.tween_callback(target.speak.bind(dialogue_choice))
	movie.tween_callback(func(): AudioManager.play_sound(load("res://audio/sfx/items/laff_boost_pickup.ogg")))
	movie.tween_callback(battle_node.focus_character.bind(target))
	movie.tween_callback(manager.affect_target.bind(target, heal_amount))
	movie.tween_interval(3.0)
	
	# Cleanup
	await movie.finished
	movie.kill()
