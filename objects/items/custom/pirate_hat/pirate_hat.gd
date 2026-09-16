extends Node3D

var resource: Item

func setup(item: Item):
	resource = item
	# Reroll pirate hat if we don't have proxies unlocked
	# Its effect is only valid for proxy cogs
	if not SaveFileService.progress_file.proxies_unlocked:
		item.reroll()
		print('Rerolling pirate hat because proxy cogs not unlocked')
