extends CogAttack
const COG := preload('res://objects/cog/cog.tscn')
const STATUS_EFFECT := preload('res://objects/battle/battle_resources/status_effects/resources/status_effect_insurance_plan.tres')

const PHRASES := [
	"Hmph...",
	"Hrnhmpf...",
	"Hrm...",
	"Hm, hm..."
]
var response_lines: Array[String] = [
	"Thank you.",
	"Much obliged.",
	"Needed that.",
	"How nice of you.",
]

const CAN := preload("res://models/props/cog_props/shredder_paper/shredder_paper.fbx")
const CanPos = Vector3(0.735, 0.661, -0.653)
const CanRot = Vector3(-2.3, 46.8, 58.2)

func action() -> void:
	if len(manager.cogs) <= 1:
		return
		
	var cog_user: Cog = user
	for i in range(targets.size() - 1, -1, -1):
		var target = targets[i]
		if not target or target.stats.hp <= 0:
			targets.remove_at(i)
	if targets.is_empty():
		manager.show_action_name("", "")
		return
		
	var heal_amount := -(cog_user.stats.max_hp / 4)
	
	var movie := manager.create_tween()
	
	# Focus user
	
	manager.show_action_name("Insurance Plan", "All Cogs recives health regeneration!")
	var oil_can := CAN.instantiate()
	movie.tween_callback(cog_user.body.right_hand_bone.add_child.bind(oil_can))
	oil_can.position = CanPos
	oil_can.rotation_degrees = CanRot
	battle_node.focus_cogs()
	battle_node.battle_cam.position.z += 3
	var phrase_choice: String = RandomService.array_pick_random('true_random', PHRASES)
	movie.tween_callback(cog_user.speak.bind(phrase_choice))
	movie.tween_callback(cog_user.set_animation.bind('throw-paper'))
	movie.tween_interval(2.4)
	movie.tween_callback(func(): AudioManager.play_sound(load("res://audio/sfx/battle/cogs/attacks/SA_extra_tip.ogg")))
	movie.tween_callback(oil_can.queue_free.bind())
	movie.tween_interval(3.0)
	
	# Focus target
	movie.tween_callback(func(): AudioManager.play_sound(load("res://audio/sfx/items/laff_boost_pickup.ogg")))
	for target in targets:
		var dialogue_choice: String = RandomService.array_pick_random('true_random', response_lines)
		movie.tween_callback(apply_effect.bind(target))
		movie.tween_callback(manager.affect_target.bind(target, heal_amount))
		movie.tween_callback(target.speak.bind(dialogue_choice))
	movie.tween_callback(manager.affect_target.bind(cog_user, heal_amount))
	movie.tween_callback(apply_effect.bind(cog_user))
	movie.tween_interval(3.0)
	
	# Cleanup
	await movie.finished
	movie.kill()

func apply_effect(target: Cog) -> void:
	var effect := STATUS_EFFECT.duplicate()
	effect.target = target
	manager.add_status_effect(effect)
