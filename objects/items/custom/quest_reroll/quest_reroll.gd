extends MeshInstance3D

const MAX_REROLLS := 4


func setup(item : Item) -> void:
	if not Util.get_player():
		return
	
	var reroll_count := Util.get_player().stats.quest_rerolls
	reroll_count += ItemService.get_items_in_play("Task Reroll").size()
	
	if reroll_count > MAX_REROLLS:
		item.reroll()
