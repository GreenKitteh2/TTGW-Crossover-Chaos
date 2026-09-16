extends CogAttack

const COG_OBJECT := preload('res://objects/cog/cog.tscn')
const PHONE := preload("res://models/props/cog_props/phone_receiver/prop_phone.glb")
const RECEIVER := preload("res://models/props/cog_props/phone_receiver/prop_receiver.glb")
const SFX := preload('res://audio/sfx/battle/cogs/attacks/SA_hangup.ogg')


var spawn_proxies := false


func action() -> void: 
	var cog_amount := 1
	if len(manager.cogs) >= 5:
		return
	var user_cog : Cog = user
	
	
	
	var phone := PHONE.instantiate()
	var receiver := RECEIVER.instantiate()
	user.body.left_hand_bone.add_child(phone)
	phone.add_child(receiver)
	phone.rotation_degrees.x = -90.0
	
	# Movie Start
	var movie := manager.create_tween()
	
	# Show Cog dialing
	movie.tween_callback(battle_node.focus_character.bind(user))
	movie.tween_callback(user.set_animation.bind('phone'))
	movie.tween_interval(get_pickup_time(user_cog))
	movie.tween_callback(AudioManager.play_sound.bind(SFX))
	
	# Receiver pickup/putdown timing
	movie.tween_callback(receiver.reparent.bind(user.body.right_hand_bone))
	movie.tween_interval(get_hangup_time(user_cog))
	movie.tween_callback(receiver.reparent.bind(phone))
	movie.tween_interval(3.0)
	
	await movie.finished
	phone.queue_free()
	movie.kill()
	await manager.sleep(3.0)
	
	var new_cogs : Array[Cog] = []
	
	# Create our new Cog objects
	for i in cog_amount:
		var new_cog := COG_OBJECT.instantiate()
		if spawn_proxies:
			new_cog.use_mod_cogs_pool = true
			new_cog.level_range_offset = -1
		new_cogs.append(new_cog)
		new_cog.hide()
		battle_node.add_child(new_cog)
		new_cog.battle_start()
		BattleService.ongoing_battle.add_cog(new_cog)
	
	for cog : Cog in battle_node.cogs:
		if cog in new_cogs:
			cog.global_position = battle_node.get_cog_position(cog)
			battle_node.face_battle_center(cog)
			cog.fly_in(20.0, 0.0)
			cog.show()
		else:
			cog.move_to(battle_node.get_cog_position(cog)).finished.connect(func(): battle_node.face_battle_center(cog))
	
	battle_node.focus_cogs()
	battle_node.battle_cam.position.z += 2.0
	await manager.sleep(5.0)
	
func get_pickup_time(cog: Cog) -> float:
	if cog.dna.suit == CogDNA.SuitType.SUIT_A:
		return 1.2
	else:
		return 1.5

func get_hangup_time(cog: Cog) -> float:
	if cog.dna.suit == CogDNA.SuitType.SUIT_A:
		return 2.3
	else:
		return 3.0
