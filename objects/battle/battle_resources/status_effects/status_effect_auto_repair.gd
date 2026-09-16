@tool
extends StatusEffect

const SFX := preload("res://objects/battle/effects/cog_healing/cog_healing.tscn")


func renew() -> void:
	var battle_node := manager.battle_node
	var cog: Cog = target
	
	# Don't play if Cog dead
	if not is_instance_valid(cog) or cog.stats.hp == 0:
		return
	
	# Don't play if at full health
	if cog.stats.hp == cog.stats.max_hp and cog.stats.allow_overheal == false:
		return
	
	var heal_amount := -(cog.stats.max_hp / 5)
	
	# Movie Start
	var movie := manager.create_tween()
	
	# Focus Cog
	movie.tween_callback(battle_node.focus_character.bind(cog))
	movie.tween_callback(func(): AudioManager.play_sound(load("res://audio/sfx/battle/cogs/attacks/crossover/snd_power.ogg")))
	movie.tween_callback(manager.affect_target.bind(cog, heal_amount))
	movie.tween_interval(4.0)


	await movie.finished
	movie.kill()

func get_status_name() -> String:
	return "Auto Repair"
