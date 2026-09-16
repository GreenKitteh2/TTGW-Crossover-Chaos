@tool
extends StatusEffect

var RANDOM_COG_CHANCE := 0.15

func apply() -> void:
	Util.get_player().use_accuracy = true
	target.stats.accuracy = 0.5
	RANDOM_COG_CHANCE = 0.25
	manager.s_round_started.connect(on_round_start)
	
func expire() -> void:
	Util.get_player().use_accuracy = false
	target.stats.accuracy = 1
	RANDOM_COG_CHANCE = 0
	manager.s_round_started.disconnect(on_round_start)
	
	
func on_round_start(actions: Array[BattleAction]) -> void:
	for action in actions:
		if action is ToonAttack and randf() < RANDOM_COG_CHANCE:
			print('Randomizing action: %s' % action.action_name)
			randomize_action(action)

func randomize_action(action: ToonAttack) -> void:
	var prev_targets := action.targets
	var prev_main_target = action.main_target
	if not action.target_type == BattleAction.ActionTarget.ENEMY:
		action.targets.clear()
		action.reassess_splash_targets(randi() % BattleService.ongoing_battle.cogs.size(), BattleService.ongoing_battle)
		if not action.main_target == prev_main_target:
			Util.get_player().boost_queue.queue_text("Ad distraction!", Color(1.0, 0.91, 0.004, 1.0))
	else:
		action.targets = [BattleService.ongoing_battle.cogs.pick_random()]
		if not action.targets[0] == prev_targets[0]:
			Util.get_player().boost_queue.queue_text("Ad distraction!", Color(1.0, 1.0, 0.0, 1.0))
	action.special_action_exclude = true
