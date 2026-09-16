extends CogAttack
const STAT_BOOST := preload('res://objects/battle/battle_resources/status_effects/resources/status_effect_legal_bindings.tres')

# Config
@export var prop : PackedScene
@export var wait_time := 3.2
@export var custom_method : String

# Locals
var held_prop : Node3D
var hit: bool

func action():
	hit = manager.roll_for_accuracy(self)
	user.face_position(targets[0].global_position)
	# Hold the prop
	if prop: 
		held_prop = prop.instantiate()
	user.body.right_hand_bone.add_child(held_prop)
	user.set_animation('throw-paper')
	
	
	if has_method(custom_method):
		await Callable(self,custom_method).call()
	
	if is_instance_valid(held_prop):
		held_prop.queue_free()
		
func red_tape() -> void:
	held_prop.position = Vector3(0, 0, 0)
	held_prop.rotation_degrees = Vector3(-27.2, 176.1, -36.3)
	
	var player : Player = targets[0]
	battle_node.focus_character(user)
	
	if not hit:
		var stagger := 0.2
		await manager.sleep(wait_time - stagger)
		player.set_animation('jump')
		await manager.sleep(stagger)
	else:
		await manager.sleep(wait_time)
	
	held_prop.reparent(battle_node)
	held_prop.global_position.y = player.global_position.y + 1.5
	held_prop.look_at(player.global_position)
	
	var forward_vec := held_prop.global_transform.basis.z.normalized()
	var distance := -held_prop.global_position.distance_to(player.global_position)

	if not hit:
		distance -= 2.0
	
	var destination := held_prop.global_position + (forward_vec*distance)
	
	
	var throw_tween : Tween = held_prop.create_tween()
	throw_tween.tween_property(held_prop,'global_position', destination, 0.6)
	throw_tween.finished.connect(
		func():
			throw_tween.kill()
			held_prop.queue_free()
			if hit:
				manager.add_status_effect(create_debuff(player))
				player.set_animation("conked")
				manager.affect_target(player, damage)
				await manager.sleep(0.25)
				player.set_animation("struggle")
	)
	
	battle_node.focus_character(player)
	
	if not hit:
		manager.battle_text(player, "MISSED")
	
	await manager.barrier(player.animator.animation_finished, 5.0)
	await manager.check_pulses(targets)

func create_debuff(player : Player) -> StatBoost:
	var effect := STAT_BOOST.duplicate(true)
	effect.quality = StatusEffect.EffectQuality.NEGATIVE
	effect.target = player
	return effect
