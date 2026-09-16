extends FloorModifier

## Phrases the Cogs in the CGC will say.
const STARTER_PHRASES : Array[String] = [
	"Ugh...You messed up my chance for a hole in one!",
	"Heads up everyone, we got ourselves a triple bogey.",
	"Fly away like a birdie.",
	"Step off the Fairway Toon.",
	"Time to go Green Toon.",
	"You're in for a Rough fight.",
	"This win will be my first cut on my payout.",
	"We were about to have some Tee.",
	"I don't Condor your arrival.",
	"You can fore-get this encounter.",
	"Ah so you're willing to Par-take in this fight?",
]

const V2_CHANCE := 0.25
const PHRASE_CHANCE := 1.0 / 3.0

## 5% for cogs to be v2.0
func modify_floor() -> void:
	game_floor.s_cog_spawned.connect(
		func(cog: Cog): 
			if cog.dna or cog.skelecog:
				return
			if RandomService.randf_channel('true_random') < V2_CHANCE:
				cog.v2 = true
				cog.skelecog_chance = 0
			cog.s_dna_set.connect(cog_dna_set.bind(cog))
	)

func cog_dna_set(cog : Cog) -> void:
	if RandomService.randf_channel('true_random'):
		cog.dna.battle_phrases = STARTER_PHRASES.duplicate()

func get_mod_name() -> String:
	return "HardClub"
