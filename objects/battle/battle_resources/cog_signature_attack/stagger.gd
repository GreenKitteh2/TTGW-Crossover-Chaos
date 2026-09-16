extends CogAttack

@export var status_effect : StatBoost
const STAT_BOOST := preload('res://objects/battle/battle_resources/status_effects/resources/status_effect_stat_boost.tres')
const SFX_STOMP := preload("res://audio/sfx/misc/ENC_cogjump_to_side.ogg")

func action() -> void:
	# Get player
	var player : Player = targets[0]
	
	# Focus Cog
	user.set_animation('stomp')
	AudioManager.play_sound(SFX_STOMP)
	battle_node.focus_character(user)
	
	# Roll for accuracy
	var hit := manager.roll_for_accuracy(self)
	await manager.sleep(3.0)
	
	# Focus the player
	battle_node.focus_character(player)
	
	# Apply the status effect
	if hit:
		manager.add_status_effect(create_debuff(player))
		
		# Player reaction
		player.set_animation('slip-forward')
		await manager.barrier(player.animator.animation_finished, 4.0)
	# I find this funny but maybe another way of doing this is in order
	else:
		player.set_animation('jump')
		manager.battle_text(player,"MISSED!")
		await manager.sleep(3.0)


func create_debuff(player : Player) -> StatBoost:
	var effect := STAT_BOOST.duplicate(true)
	effect.quality = StatusEffect.EffectQuality.NEGATIVE
	effect.boost = -0.2
	effect.stat = 'evasiveness'
	effect.target = player
	return effect
