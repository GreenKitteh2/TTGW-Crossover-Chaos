extends ToonAttack
class_name GagSpell


func action() -> void:
	var target : Cog = targets[0]
	
	manager.s_focus_char.emit(user)
	var book : Node3D = load('res://models/props/toon_props/shticker_book/shticker_bookopen.fbx').instantiate()
	user.toon.right_hand_bone.add_child(book)
	user.set_animation('book_open')
	book.get_node('AnimationPlayer').play('open')
	await user.animator.animation_finished
	user.set_animation('book_neutral')
	user.toon.speak("*Reads spell that instantly kills opponent*")
	await manager.sleep(4.0)
	
	manager.s_focus_char.emit(target)
	target.speak("There is no way that is going to-")
	await manager.sleep(1.0)
	manager.someone_died(target)
	target.queue_free()
	await manager.sleep(2.0)
	
	book.queue_free()
