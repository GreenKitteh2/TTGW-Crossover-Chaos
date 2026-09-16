extends FloorModifier

## Phrases the Cogs in the Office will say.
const STARTER_PHRASES : Array[String] = [
	"Can't bail out of this one Toon.",
	"The Clerk is in charge of this facility.",
	"You'll find this feature Aggravating.",
	"We're having a brief on your evidence.",
	"Your Toon Council will be hearing this.",
	"Do you wish to plea for mercy?",
	"I forgot to mention about this Toon.",
	"I beg your pardon Toon?",
	"We're putting a tort to your plans.",
	"You are in no room for Deposition.",
	"Nothing like a simple Clause and effect.",
]

func modify_floor() -> void:
	game_floor.level_range += Vector2i(1, 1)
	game_floor.s_cog_spawned.connect(
		func(cog: Cog): 
			cog.s_dna_set.connect(cog_dna_set.bind(cog))
	)


func cog_dna_set(cog : Cog) -> void:
	if RandomService.randf_channel('true_random'):
		cog.dna.battle_phrases = STARTER_PHRASES.duplicate()

func get_mod_name() -> String:
	return "HardOffice"
