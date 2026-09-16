extends Node3D

var cogs: Array[Cog]

func _ready() -> void:
	cogs.assign(NodeGlobals.get_children_of_type(self, Cog, true))
	for cog: Cog in cogs:
		cog.body.nametag_node.hide()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		%penthouse.hide()
		%Cogs.show()
		await get_tree().process_frame
		var new_file_path: String = 'res://scenes/test/directors-screenshot-cogs.png'
		get_viewport().get_texture().get_image().save_png(new_file_path)
		print_rich("[color=green]Saved[/color] screenshot at [color=light_blue]%s[/color]" % new_file_path)
	elif Input.is_action_just_pressed("pause"):
		%penthouse.show()
		%Cogs.hide()
		await get_tree().process_frame
		var new_file_path: String = 'res://scenes/test/directors-screenshot-office.png'
		get_viewport().get_texture().get_image().save_png(new_file_path)
		print_rich("[color=green]Saved[/color] screenshot at [color=light_blue]%s[/color]" % new_file_path)
