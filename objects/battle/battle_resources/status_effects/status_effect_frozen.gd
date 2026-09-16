@tool
extends StatusEffect

func apply() -> void:
	manager.s_round_started.connect(round_started)

func expire() -> void:
	manager.s_round_started.disconnect(round_started)

func round_started(round_actions: Array[BattleAction]) -> void:
	var index := 0
	var seen_actions : Array[BattleAction] = []
		
	while index < round_actions.size():
		var action := round_actions[index]
		
		# Move all toon attacks to the back of the round actions
		if not action is ToonAttack or action in seen_actions:
			index += 1
			seen_actions.append(action)
		else:
			round_actions.remove_at(index)
			round_actions.append(action)
			seen_actions.append(action)
	
	BattleService.ongoing_battle.round_actions = round_actions

func cleanup() -> void:
	manager.s_round_started.disconnect(round_started)
