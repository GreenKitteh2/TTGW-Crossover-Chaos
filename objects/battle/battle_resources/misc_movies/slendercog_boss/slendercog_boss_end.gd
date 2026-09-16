extends ActionScript
class_name SlenderBossEnd

var slendercog_directory : Node3D


func action() -> void:
	if not slendercog_directory:
		return
	
	# Get required values
	var noise_tex : TextureRect = slendercog_directory.tv_static
	var static_meter : Panel = slendercog_directory.static_meter
	var player := Util.get_player()
	
	# MOVIE START
	var movie_tween := manager.create_tween()
	
	# Focus player as the static drains to 0
	movie_tween.tween_callback(battle_node.focus_character.bind(player))
	movie_tween.tween_method(noise_tex.set_alpha, noise_tex.modulate.a, 0.0, 3.0)
	movie_tween.tween_callback(static_meter.hide)
	
	# Stop all static sfx
	for audio_player : AudioStreamPlayer in slendercog_directory.sfx_static.get_children():
		movie_tween.tween_callback(audio_player.stop)
	
	await movie_tween.finished
	movie_tween.kill()
