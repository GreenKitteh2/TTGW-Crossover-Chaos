@tool
extends Node3D

@export var want_shadow := true:
	set(x):
		want_shadow = x
		await NodeGlobals.until_ready(self)
		%CBWoodBoxShadow.visible = want_shadow
