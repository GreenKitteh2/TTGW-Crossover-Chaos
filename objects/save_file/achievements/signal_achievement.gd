extends Achievement
class_name SignalAchievement

enum SignalSource {
	UTIL,
	GLOBALS,
	BATTLESERVICE,
	ITEMSERVICE,
}
@export var signal_source : SignalSource
@export var signal_name :=  ""

func _setup() -> void:
	if get_completed():
		return
	
	var connected_signal = get_signal()
	if connected_signal is Signal:
		connected_signal.connect(attempt_unlock)

func get_signal() -> Variant:
	var node := get_signal_source()
	if not node:
		return null
	
	if signal_name in node:
		if node.get(signal_name) is Signal:
			return node.get(signal_name)
	
	return null

func attempt_unlock(_arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null) -> void:
	if not get_completed():
		unlock()

func get_signal_source() -> Node:
	match signal_source:
		SignalSource.UTIL: return Util
		SignalSource.GLOBALS: return Globals
		SignalSource.BATTLESERVICE : return BattleService
		SignalSource.ITEMSERVICE : return ItemService
	return null
