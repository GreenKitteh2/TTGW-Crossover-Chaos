extends FloorModifier

const STARTER_PHRASES : Array[String] = [
	"WHAT HAVE THEY DONE TO ME!",
	"My partner ran off, Do you see them?",
	"I shouldn't have agreed to this...",
	"I didn't sign up for this!",
	"We're just as horrified as you are Toon.",
	"DON'T LOOK AT ME!",
	"Nothing makes sense!",
	"I should've read the terms and conditions before agreeing to this.",
	"I look horrible!",
	"I could've just called in sick.",
	"How do I explain all this to the insurance.",
]

const PHRASE_CHANCE := 1.0 / 3.0

## Turns all Cogs on floor into fusions
func modify_floor() -> void:
	game_floor.s_cog_spawned.connect(
		func(cog: Cog): 
			if cog.fusion_chance >= 0:
				cog.fusion = true
				cog.skelecog_chance = 0
				cog.skelecog = false
			cog.s_dna_set.connect(cog_dna_set.bind(cog))
	)

func cog_dna_set(cog : Cog) -> void:
	if RandomService.randf_channel('true_random'):
		cog.dna.battle_phrases = STARTER_PHRASES.duplicate()
		
func get_mod_name() -> String:
	return "Dementia"
