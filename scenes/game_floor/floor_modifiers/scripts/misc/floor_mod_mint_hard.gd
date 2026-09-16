extends FloorModifier

## Phrases the Cogs in the Mint will say.
const STARTER_PHRASES : Array[String] = [
	"Sink or Swim Toon, We flood the market.",
	"Those Gags cost extra here by the way.",
	"Here for a loan? course you don't.",
	"It's never to late to mortgage your estate.",
	"It seems your town is suffering a loss.",
	"I'd withdrawl from this battle if I were you.",
	"Your investment couldn't beat our interest.",
	"Couldn't hear you, Money is talking.",
	"No matter what you do to our assets, it will remain fixed.",
	"Jellybeans? Currency? Yuck!",
	"Common Cents Toon, Common Cents.",
]

func modify_floor() -> void:
	var player := Util.get_player()
	player.stats.gag_discount -= 1
	game_floor.s_cog_spawned.connect(
		func(cog: Cog): 
			cog.s_dna_set.connect(cog_dna_set.bind(cog))
	)

func clean_up() -> void:
	var player := Util.get_player()
	player.stats.gag_discount += 1

func cog_dna_set(cog : Cog) -> void:
	if RandomService.randf_channel('true_random'):
		cog.dna.battle_phrases = STARTER_PHRASES.duplicate()

func get_mod_name() -> String:
	return "HardMint"
