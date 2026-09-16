extends CogAttack
const COG_REGEN_EFFECT := preload("res://objects/battle/effects/cog_healing/cog_healing.tscn")


func action() -> void:
	var cog: Cog = user
	do_cog_regen_tween(cog)
	
	var heal_amount := -(cog.stats.max_hp / 4)
	
	var tween := manager.create_tween()
	tween.tween_callback(battle_node.focus_character.bind(cog))
	tween.tween_callback(func(): AudioManager.play_sound(load("res://audio/sfx/battle/cogs/attacks/crossover/snd_power.ogg")))
	tween.tween_callback(cog.set_animation.bind('buffed'))
	tween.tween_callback(manager.affect_target.bind(cog, heal_amount))
	tween.tween_interval(4.0)
	
	await tween.finished
	tween.kill()

func do_cog_regen_tween(cog : Cog) -> void:
	var particle : Node3D = COG_REGEN_EFFECT.instantiate()
	particle.scale *= 0.01
	particle.position.y = 0.05
	cog.body_root.add_child(particle)
	var tween := manager.create_tween().set_trans(Tween.TRANS_EXPO)
	tween.tween_property(particle, 'scale', Vector3.ONE * cog.dna.scale, 0.5)
	tween.tween_interval(1.5)
	tween.tween_property(particle, 'scale', Vector3.ONE * 0.01, 0.5)
	tween.tween_callback(particle.queue_free)
	tween.finished.connect(tween.kill)
