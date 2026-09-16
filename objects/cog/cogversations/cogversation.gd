extends Resource
class_name Cogversation

## Set this to the index the speaking Cog has said earlier in the cogversation.
@export var reply_to_index := -1
@export_multiline var message : String
@export var follow_up : Cogversation
var speaker : Cog



func to_array() -> Array[Cogversation]:
	var cogversation := self
	var cogversation_array : Array[Cogversation] = [self]
	while cogversation.follow_up:
		cogversation_array.append(cogversation.follow_up)
		cogversation = cogversation.follow_up
	return cogversation_array

func find(cogversation : Cogversation) -> int:
	return to_array().find(cogversation)
