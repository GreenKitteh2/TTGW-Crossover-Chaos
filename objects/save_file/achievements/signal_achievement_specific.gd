extends SignalAchievement
class_name SignalAchievementSpecific


## Alright hear me out.
## You can't export a variant,
## But a general array can take just about any value.
## Put the value you're listening for in the first index of the array.
## I am very clever.
@export var value : Array



func attempt_unlock(arg1 = null, _arg2 = null, _arg3 = null, _arg4 = null) -> void:
	if not value.is_empty():
		if not arg1 == value[0]:
			return
	
	if not get_completed():
		unlock()
