@tool
extends StatusEffect

@export var damage_redirected: float = 0.4

var scapegoat: Cog

func apply() -> void:
	BattleService.s_toon_dealt_damage.connect(redirect_damage)

func cleanup() -> void:
	if BattleService.s_toon_dealt_damage.is_connected(redirect_damage):
		BattleService.s_toon_dealt_damage.disconnect(redirect_damage)

func redirect_damage(_action: BattleAction, cog: Node3D, amount: int):
	if amount < 0 or cog == scapegoat:
		return
	if (not is_instance_valid(target)) or target.stats.hp <= 0:
		return
	
	manager.affect_target(target, amount * damage_redirected)
	target.set_animation("pie-small")
	await manager.barrier(target.animator.animation_finished, 4.0)
	await manager.check_pulses([target])
