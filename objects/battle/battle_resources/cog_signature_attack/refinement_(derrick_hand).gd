extends CogAttack
const COG := preload('res://objects/cog/cog.tscn')

const PHRASES := [
	"It's important to stay adequately oiled when defeating Toons.",
	"Freshly drilled to keep us in working order."
]
var response_lines: Array[String] = [
	"Thank you.",
	"Much obliged.",
	"Needed that.",
	"How nice of you.",
]

const CAN := preload("res://models/props/cog_props/oil_can/oil_can_(plateless).fbx")
const CanPos = Vector3(0.735, 0.661, -0.653)
const CanRot = Vector3(-2.3, 46.8, 58.2)

const SFX_OIL_CAN := preload("res://audio/sfx/battle/cogs/attacks/SA_refinement.ogg")
const SFX_HEAL := preload("res://audio/sfx/items/laff_boost_pickup.ogg")

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

	manager.show_action_name("Refinement!", "Heals all Cogs for 40% of their HP!")
	battle_node.focus_cogs()
	battle_node.battle_cam.position.z += 3.0

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
	movie.tween_callback(func(): AudioManager.play_sound(load("res://audio/sfx/battle/cogs/attacks/SA_refinement.ogg")))
	movie.tween_callback(oil_can.queue_free.bind())
	movie.tween_interval(3.0)
	movie.tween_callback(func(): AudioManager.play_sound(load("res://audio/sfx/items/laff_boost_pickup.ogg")))
	for target in targets:
		var dialogue_choice: String = RandomService.array_pick_random('true_random', response_lines)
		movie.tween_callback(manager.affect_target.bind(target, -(target.stats.max_hp / 4)))
		movie.tween_callback(target.speak.bind(dialogue_choice))
	movie.tween_callback(manager.affect_target.bind(cog_user, heal_amount))
	movie.tween_interval(3.0)
	
	await movie.finished
	movie.kill()
