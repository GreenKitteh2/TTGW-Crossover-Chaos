extends FloorModifier

## Phrases the Cogs in the Factory will say.
const STARTER_PHRASES : Array[String] = [
	"Chop chop Toon, We don't have all day.",
	"Mr. Foreman doesn't want time for tomfoolery.",
	"We're on a clock Toon, step it up.",
	"Let's get this done and over with, we got stuff to do.",
	"We have a strict schedule.",
	"Sense of humor is off the timetable i'm afraid.",
	"Not now Toon, I already have part of my paycheck taken out.",
	"We got a quota, should've just waited.",
	"Now is not the time.",
	"We know you're here now quit wasting our time!",
	"No setbacks, again, No setbacks!",
]

const BATTLE_TIME := 20

func modify_floor() -> void:
	var player := Util.get_player()
	player.stats.battle_timers.append(BATTLE_TIME)
	game_floor.s_cog_spawned.connect(
		func(cog: Cog): 
			cog.s_dna_set.connect(cog_dna_set.bind(cog))
	)

func clean_up() -> void:
	var player := Util.get_player()
	player.stats.battle_timers.erase(BATTLE_TIME)

func cog_dna_set(cog : Cog) -> void:
	if RandomService.randf_channel('true_random'):
		cog.dna.battle_phrases = STARTER_PHRASES.duplicate()

func get_mod_name() -> String:
	return "HardFactory"
