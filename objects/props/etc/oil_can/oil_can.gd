@tool
extends Node3D

@export var want_tray := true:
	set(x):
		want_tray = x
		if not is_node_ready():
			await ready
		%tray.visible = want_tray
