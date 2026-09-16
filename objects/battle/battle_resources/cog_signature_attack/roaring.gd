extends CogAttack

const BOOST_AMT := 0.5
const COG_ROARING_EFFECT := preload("res://objects/battle/effects/cog_roaring/cog_roaring.tscn")

const STATUS_EFFECT := preload('res://objects/battle/battle_resources/status_effects/resources/status_effect_roaring.tres')



func action() -> void:
	var cog: Cog = user
	apply_effect(cog)
	do_cog_roaring_tween(cog)

	var tween := manager.create_tween()
	tween.tween_callback(func(): AudioManager.play_sound(load("res://audio/sfx/battle/cogs/attacks/crossover/snd_knightroar.ogg")))
	tween.tween_callback(battle_node.focus_character.bind(cog))
	tween.tween_callback(cog.set_animation.bind('buffed'))
	tween.tween_interval(3.0)
	
	await tween.finished
	tween.kill()

func do_cog_roaring_tween(cog : Cog) -> void:
	var particle : Node3D = COG_ROARING_EFFECT.instantiate()
	particle.scale *= 0.01
	particle.position.y = 0.05
	cog.body_root.add_child(particle)
	var tween := manager.create_tween().set_trans(Tween.TRANS_EXPO)
	tween.tween_property(particle, 'scale', Vector3.ONE * cog.dna.scale, 0.5)
	tween.tween_interval(1.5)
	tween.tween_property(particle, 'scale', Vector3.ONE * 0.01, 0.5)
	tween.tween_callback(particle.queue_free)
	tween.finished.connect(tween.kill)
	
func apply_effect(cog : Cog) -> void:
	var effect := STATUS_EFFECT.duplicate()
	effect.rounds = 3
	effect.target = cog
	manager.add_status_effect(effect)
