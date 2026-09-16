extends CogAttack

const COG := preload('res://objects/cog/cog.tscn')
const SFX_SPARK := preload("res://audio/sfx/battle/cogs/misc/LB_sparks_1.ogg")
const GAG_IMMUNITY_EFFECT := preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_gag_immunity.tres")

const PHRASES := [
	"My Lost Jury, all rise from your grave!",
	"Come forth fallen angels, Judgement has come!",
	"My aid is needed, let this battle free your soul.",
	"Arise! We will never rest until this toon is perished!",
	"Ruined Court is now in session!",
	"I will not fight alone.",
]

func action() -> void:
	manager.show_action_name("Jury Reselection!", "Resurrects Cogs into battle!")
	var cogs: Array[Cog] = []
	var user_cog: Cog = user
	
	var dialogue_choice: String = RandomService.array_pick_random('true_random', PHRASES)
	
	
	for i in 4:
		var cog := COG.instantiate()
		cog.ghost_cog = true
		cog.hide()
		battle_node.add_child(cog)
		cog.battle_start()
		cogs.append(cog)
	assign_gag_immunities(cogs)

	# Add new Cogs to the battle
	for cog in cogs:
		manager.add_cog(cog)

	# Move user cog to index 2
	manager.cogs.erase(user_cog)
	manager.cogs.insert(2, user_cog)

	# Reposition the Cogs in battle
	battle_node.reposition_cogs()
	
	var movie := manager.create_tween()
	movie.tween_callback(user_cog.speak.bind(dialogue_choice))
	movie.tween_callback(battle_node.focus_cogs)
	movie.tween_callback(battle_node.focus_character.bind(user, 6.0))
	movie.tween_interval(3)
	movie.tween_callback(AudioManager.play_sound.bind(SFX_SPARK))
	for cog in cogs:
		movie.tween_callback(cog.show)
		movie.tween_callback(cog.set_animation.bind('drop'))
		movie.tween_callback(cog.animator_seek.bind(1.5))
	movie.tween_interval(3.0)
	
	await movie.finished
	movie.kill()

func assign_gag_immunities(cogs: Array[Cog]) -> Array[StatusEffectGagImmunity]:
	var effects: Array[StatusEffectGagImmunity] = []
	var loadout: Array[Track] = Util.get_player().stats.character.gag_loadout.loadout
	
	# Assign a random gag immunity to each Cog
	for cog in cogs:
		var new_status := GAG_IMMUNITY_EFFECT.duplicate()
		new_status.target = cog
		new_status.rounds = -1
		new_status.set_track(loadout[RandomService.randi_channel('true_random') % loadout.size()])
		cog.status_effects.append(new_status)
		cog.body.set_color(Color(new_status.track.track_color, 0.8))
	
	return effects
