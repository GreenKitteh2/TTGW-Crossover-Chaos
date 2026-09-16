extends HBoxContainer

@export var target: Node3D:
	set(x):
		target = x
		refresh()

func _ready() -> void:
	BattleService.s_refresh_statuses.connect(refresh)

func refresh() -> void:
	for icon: StatusEffectIcon in get_children():
		icon.queue_free()
	build_icons()

func build_icons() -> void:
	if not BattleService.ongoing_battle:
		return
	for status: StatusEffect in BattleService.ongoing_battle.get_statuses_for_target(target):
		if not status.visible:
			continue

		var new_icon: StatusEffectIcon = StatusEffectIcon.create()
		new_icon.effect = status
		add_child(new_icon)
