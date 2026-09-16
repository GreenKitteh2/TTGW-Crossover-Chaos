extends Resource
class_name BattleStartMovie

# Not preloaded bc it shouldn't be needed
const FALLBACK_MUSIC := "res://audio/music/encntr_general_bg.ogg"

const super_battle_music := [
	"res://audio/music/superbattles/Air_Waves.ogg",
	"res://audio/music/superbattles/Attack_of_the_killer_queen.ogg",
	"res://audio/music/superbattles/A_dark_zone.ogg",
	"res://audio/music/superbattles/Bigfoot.ogg",
	"res://audio/music/superbattles/Black_Knife.ogg",
	"res://audio/music/superbattles/Bonetrousle.ogg",
	"res://audio/music/superbattles/Bubonic_Plant.ogg",
	"res://audio/music/superbattles/Burning_eyes.ogg",
	"res://audio/music/superbattles/Catswing.ogg",
	"res://audio/music/superbattles/Chaos_King.ogg",
	"res://audio/music/superbattles/Checker_Dance.ogg",
	"res://audio/music/superbattles/Cruel_King.ogg",
	"res://audio/music/superbattles/Cutie_Mew_Mew_Magic.ogg",
	"res://audio/music/superbattles/Death_by_Glamor.ogg",
	"res://audio/music/superbattles/Dummy.ogg",
	"res://audio/music/superbattles/Fear.ogg",
	"res://audio/music/superbattles/Flower_Man.ogg",
	"res://audio/music/superbattles/Ghost_Fight.ogg",
	"res://audio/music/superbattles/Greed.ogg",
	"res://audio/music/superbattles/Greenhouse.ogg",
	"res://audio/music/superbattles/Griefer.ogg",
	"res://audio/music/superbattles/Guardian.ogg",
	"res://audio/music/superbattles/Hammer_of_Justice.ogg",
	"res://audio/music/superbattles/Hatred.ogg",
	"res://audio/music/superbattles/Heartache.ogg",
	"res://audio/music/superbattles/Its_Tv_Time.ogg",
	"res://audio/music/superbattles/Mad_Mew_Mew.ogg",
	"res://audio/music/superbattles/Megalovania.ogg",
	"res://audio/music/superbattles/Metal_Crusher.ogg",
	"res://audio/music/superbattles/Noobador.ogg",
	"res://audio/music/superbattles/Petal_Dance.ogg",
	"res://audio/music/superbattles/Power_of_Neo.ogg",
	"res://audio/music/superbattles/Sentient_Statue.ogg",
	"res://audio/music/superbattles/Smart_Race.ogg",
	"res://audio/music/superbattles/Solitude.ogg",
	"res://audio/music/superbattles/Spear_of_Justice.ogg",
	"res://audio/music/superbattles/Spider_Dance.ogg",
	"res://audio/music/superbattles/Supreme_Ant.ogg",
	"res://audio/music/superbattles/The_World_Revolving.ogg",
	"res://audio/music/superbattles/TutorialTerry.ogg",
	"res://audio/music/superbattles/Undyne_the_Undying.ogg",
	"res://audio/music/superbattles/Violet_Tactics.ogg",
	"res://audio/music/superbattles/Vs_Lancer.ogg",
	"res://audio/music/superbattles/Vs_Susie.ogg",
]

@export var skippable := false
@export var override_music : AudioStream

var battle_node : BattleNode
var camera : Camera3D
var focus_cog : Cog
var cogs : Array[Cog] = []
var override_shaking := false

var movie : Tween


## Run this to start the movie
## Default battle start movie example
func play() -> Tween:
	for cog in cogs:
		if cog.dna.is_manager:
			focus_cog = cog
	movie = create_tween()
	movie.tween_callback(battle_node.focus_character.bind(focus_cog))
	movie.tween_callback(focus_cog.speak.bind(focus_cog.dna.battle_phrases.pick_random()))
	
	# Start the battle music
	movie.tween_callback(start_music)
	if battle_node.super_battle:
		movie.tween_callback(start_music)
	
	movie.tween_interval(2.0)
	
	return movie

func _skip() -> void:
	if movie and movie.is_running():
		movie.custom_step(1000000.0)
		movie.kill()

func focus_random_cog(dial := "") -> Cog:
	if cogs.size() == 0:
		return null
	var cog: Cog = cogs.pick_random()
	battle_node.focus_character(cog, -4.01)
	if not dial == "":
		cog.speak(dial)
	return cog

## Attempts to start music, if correct music cannot be found, returns false.
func start_music(music : AudioStream = null) -> bool:
	# If music is directly specified, use that.
	if music:
		AudioManager.set_music(music)
		return true
	# If there is override music specified in the resource, use that.
	elif override_music:
		AudioManager.set_music(override_music)
		return true
	elif battle_node.super_battle:
		AudioManager.set_music(load(super_battle_music[RandomService.randi_channel('true_random') % super_battle_music.size()]))
		return true
	# If all else fails, try the default battle track for the game floor
	elif Util.floor_manager and Util.floor_manager.floor_rooms.battle_music:
		AudioManager.set_music(load(Util.floor_manager.floor_rooms.battle_music[RandomService.randi_channel('true_random') % Util.floor_manager.floor_rooms.battle_music.size()]))
		for cog in cogs:
			if cog.dna.is_manager:
				AudioManager.set_music(load(super_battle_music[RandomService.randi_channel('true_random') % super_battle_music.size()]))
				return true
		return true
	# If no track can be specified, use the fallback track
	AudioManager.set_music(load(FALLBACK_MUSIC))
	return false

## It's a resource so it can't tween by default
func create_tween() -> Tween:
	var new_tween := battle_node.create_tween()
	new_tween.finished.connect(func(): new_tween.kill())
	return new_tween

## Runs look at on an object
func face_object_towards(object_from : Node3D, object_to : Node3D) -> void:
	object_from.look_at(object_to.global_position)

func face_character(character_from : Actor, node_to : Node3D) -> void:
	character_from.face_position(node_to.global_position)

## USEFUl UNIVERSAL CUTSCENE FUNCTIONS ## 
func shake_camera(cam : Camera3D, time : float, offset : float, taper := true, x := true, y := true, z := true) -> void:
	var base_pos := cam.global_position
	var shaking := true
	
	var timer := cam.get_tree().create_timer(time)
	
	while shaking and not override_shaking:
		await Util.s_process_frame
		var new_offset : float
		if taper:
			new_offset = offset * timer.time_left/time
		else:
			new_offset = offset
		if x:
			cam.global_position.x = base_pos.x + randf_range(-new_offset,new_offset)
		if y:
			cam.global_position.y = base_pos.y + randf_range(-new_offset,new_offset)
		if z:
			cam.global_position.z = base_pos.z + randf_range(-new_offset,new_offset)
		
		if timer.time_left <= 0 or override_shaking:
			shaking = false
