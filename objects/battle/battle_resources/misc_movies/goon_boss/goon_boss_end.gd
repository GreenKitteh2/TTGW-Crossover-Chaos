extends ActionScript
class_name GoonBossEnd


func action() -> void:
	var goon : Goon = user
	goon.get_node('Skeleton3D/LightBone/CogGears').show()
	battle_node.battle_cam.global_transform = goon.get_parent().get_camera_angle('LoseCam')
	
	# Movie Start
	var movie := manager.create_tween()
	movie.tween_callback(goon.set_animation.bind('lose'))
	movie.tween_callback(goon.play_sfx.bind(goon.SFX_ALERT))
	movie.tween_method(goon.set_eye_color,goon.eye_mat.albedo_color,Color.DARK_RED,2.0)
	movie.parallel().tween_method(goon.audio_player.set_pitch_scale,0.85,3.0,3.0).set_delay(0.4)
	movie.parallel().tween_property(battle_node.battle_cam,'position:z',-2.0,3.5).as_relative()
	
	# Goon explode
	movie.tween_callback(goon.audio_player.set_pitch_scale.bind(0.85))
	movie.tween_callback(goon.explode)
	movie.tween_interval(3.0)
	
	await movie.finished
	movie.kill()
