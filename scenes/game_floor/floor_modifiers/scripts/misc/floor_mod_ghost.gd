extends FloorModifier
const GAG_IMMUNITY_EFFECT := preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_gag_immunity.tres")
const STARTER_PHRASES : Array[String] = [
	"About time you showed up, We have unfinished business.",
	"This is your fault that I have to work etnerally!",
	"I've worked my life off just for you to tear it down.",
	"Boo!",
	"We're all stuck here because of you.",
	"Remember me?",
	"I was given a second chance...to get rid of you.",
	"We can't move on, and you're the reason why.",
	"This will be a real thriller dealing with you.",
	"Don't you toons have any reconciderations?.",
	"I've haven't gotten my last breath, but you will.",
]

## Turns all Cogs on floor into Ghosts
func modify_floor() -> void:
	game_floor.s_cog_spawned.connect(
		func(cog: Cog): 
			if cog.ghost_cog == false:
				cog.ghost_cog = true
				await cog.s_dna_set
				var loadout : Array[Track] = Util.get_player().stats.character.gag_loadout.loadout
				var new_status := GAG_IMMUNITY_EFFECT.duplicate()
				new_status.target = cog
				new_status.rounds = -1
				new_status.set_track(loadout[randi() % loadout.size()])
				cog.status_effects.append(new_status)
				cog.body.set_color(Color(new_status.track.track_color, 0.8))
			cog.s_dna_set.connect(cog_dna_set.bind(cog))
	)

func cog_dna_set(cog : Cog) -> void:
	if RandomService.randf_channel('true_random'):
		cog.dna.battle_phrases = STARTER_PHRASES.duplicate()
		
func get_mod_name() -> String:
	return "GhostCogs"
