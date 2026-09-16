extends CogAttack

const COG := preload('res://objects/cog/cog.tscn')
const GAG_IMMUNITY_EFFECT := preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_gag_immunity.tres")

var response_lines: Array[String] = [
	"Lovely!",
	"Good, makes my job even more easier.",
	"I'd find this generous Atticus Wing."
]

func action() -> void:
	var cog : Cog = user
	var target : Cog = targets[0]
	
	# MOVIE START
	var movie := manager.create_tween()
	
	# Focus user
	movie.tween_callback(battle_node.focus_character.bind(cog))
	movie.tween_callback(cog.set_animation.bind('magic1'))
	movie.tween_callback(cog.face_position.bind(target.global_position))
	movie.tween_interval(5.0)
	
	# Focus target
	var dialogue_choice: String = RandomService.array_pick_random('true_random', response_lines)
	movie.tween_callback(target.set_animation.bind('buffed'))
	movie.tween_callback(target.speak.bind(dialogue_choice))
	movie.tween_callback(battle_node.focus_character.bind(target))
	movie.tween_callback(assign_gag_immunities)
	movie.tween_callback(manager.battle_text.bind(target, "Extra Immunity", BattleText.colors.orange[0], BattleText.colors.orange[1]))
	movie.tween_interval(3.0)
	
	# Cleanup
	await movie.finished
	movie.kill()

func apply_effect() -> void:
	var effect := GAG_IMMUNITY_EFFECT.duplicate()
	effect.target = targets[0]
	manager.add_status_effect(effect)

func assign_gag_immunities() -> Array[StatusEffectGagImmunity]:
	var effects: Array[StatusEffectGagImmunity] = []
	var loadout: Array[Track] = Util.get_player().stats.character.gag_loadout.loadout

	var new_status := GAG_IMMUNITY_EFFECT.duplicate()
	new_status.target = targets[0]
	new_status.rounds = 2
	new_status.set_track(loadout[RandomService.randi_channel('true_random') % loadout.size()])
	manager.add_status_effect(new_status)
	
	return effects
