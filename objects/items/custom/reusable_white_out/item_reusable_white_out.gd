extends ItemScriptActive

const TRANSITION := preload("res://objects/items/custom/white_out/white_out_transition.tscn")

func use() -> void:
	if not is_instance_valid(Util.floor_manager):
		cancel_use()
		return
	
	get_tree().get_root().add_child(TRANSITION.instantiate())
	Util.get_player().state = Player.PlayerState.STOPPED
	Util.get_player().set_animation('neutral')
	var randomdef:= RandomService.randf_range_channel('tough_crowd_mod', -0.1, 0.1)
	Util.get_player().stats.defense += randomdef
	var randomatk:= RandomService.randf_range_channel('tough_crowd_mod', -0.1, 0.1)
	Util.get_player().stats.damage += randomatk
	var randomeva:= RandomService.randf_range_channel('tough_crowd_mod', -0.1, 0.1)
	Util.get_player().stats.evasiveness += randomeva
	var randomluk:= RandomService.randf_range_channel('tough_crowd_mod', -0.1, 0.1)
	Util.get_player().stats.luck += randomluk
	
