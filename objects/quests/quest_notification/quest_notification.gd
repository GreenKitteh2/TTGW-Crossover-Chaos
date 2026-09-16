extends Control

const SHAKE_INTERVAL := 0.1
const SCALE_TIME := 0.5


@onready var scroll := $NotificationAnchor/QuestScroll

var notify_tween : Tween


func _ready() -> void:
	if not Engine.is_editor_hint():
		BattleService.s_battle_ended.connect(on_battle_end)

func on_battle_end() -> void:
	for quest in Util.get_player().stats.quests:
		if quest.is_complete():
			notify()
			break

func notify() -> void:
	if notify_tween and notify_tween.is_valid():
		notify_tween.kill()
	
	
	notify_tween = create_tween()
	notify_tween.tween_callback($SFXPlayer.play)
	notify_tween.set_trans(Tween.TRANS_QUAD)
	notify_tween.tween_property(scroll, 'position:x', -144.0, 0.5)
	notify_tween.parallel().tween_property(scroll,'scale', Vector2(1.25,1.25), SCALE_TIME)
	var shake_time := 0.0
	var shake_angle := 10.0
	while shake_time < SCALE_TIME * 2.0:
		notify_tween.parallel().tween_property(scroll,'rotation_degrees',shake_angle, SHAKE_INTERVAL).set_delay(shake_time)
		shake_time += SHAKE_INTERVAL
		shake_angle = -shake_angle
	notify_tween.tween_property(scroll,'scale', Vector2(1,1), SCALE_TIME)
	shake_time = 0.0
	while shake_time < SCALE_TIME:
		if shake_time + SHAKE_INTERVAL >= SCALE_TIME:
			notify_tween.parallel().tween_property(scroll,'rotation_degrees',0.0, SHAKE_INTERVAL).set_delay(shake_time)
		else:
			notify_tween.parallel().tween_property(scroll,'rotation_degrees',shake_angle, SHAKE_INTERVAL).set_delay(shake_time)
		shake_time += SHAKE_INTERVAL
		shake_angle = -shake_angle
	notify_tween.parallel().tween_property(scroll, 'position:x', 48.0, 0.5)
	notify_tween.finished.connect(notify_tween.kill)
