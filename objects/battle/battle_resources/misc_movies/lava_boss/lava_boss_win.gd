extends ActionScript
class_name LavaBossWin

const DRAIN_POS := -13.0
const SINK_POS := -14.0

var lava: Node3D
var lava_particles: GPUParticles3D
var lava_plane: MeshInstance3D
var platform: Node3D

## Create a tween to "drain" the lava
func action():
	manager.battle_node.battle_cam.global_transform = user.sink_pos.global_transform
	var drain_tween: Tween = lava.create_tween()
	drain_tween.set_trans(Tween.TRANS_QUAD)
	drain_tween.tween_property(lava, 'position:y', DRAIN_POS, 2.0)
	drain_tween.parallel().tween_property(platform, 'position:y', SINK_POS, 2.0)
	drain_tween.parallel().tween_callback(func(): lava_particles.emitting = false)
	drain_tween.tween_callback(func(): lava_plane.hide())
	await drain_tween.finished
	drain_tween.kill()
	await manager.sleep(2.0)
