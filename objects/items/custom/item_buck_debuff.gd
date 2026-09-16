extends ItemScript
const AGILE := preload("res://objects/battle/battle_resources/status_effects/resources/mod_cog_agile_(buck).tres")

const RANDOM_EFFECTS: Array[StatusEffect] =[
	preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_stat_boost.tres"),
	preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_poison.tres"),
	preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_aftershock.tres"),
	preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_drenched.tres"),
	preload("res://objects/battle/battle_resources/status_effects/resources/status_effect_staggered.tres"),
]

var cog_hps: Dictionary[Cog, int] = {}

func on_collect(_item: Item, _object: Node3D) -> void:
	setup()
	
func on_load(_item: Item) -> void:
	setup()

func setup() -> void:
	BattleService.s_battle_started.connect(try_apply_agile)
	BattleService.s_battle_started.connect(on_battle_start)

func try_apply_agile(manager: BattleManager) -> void:
	
	for i in range(manager.cogs.size() - 1, -1, -1):
		var cog = manager.cogs[i]
		if not cog or cog.stats.hp <= 0:
			manager.cogs.remove_at(i)
	if manager.cogs.is_empty():
		manager.show_action_name("", "")
		return
		
	# Pick a random cog in the battle and apply the auto-drop status onto them.
	for cog in manager.cogs:
		if cog.dna and cog.dna.is_crossover_cog:
			var new_status := AGILE.duplicate(true)
			new_status.target = cog
			manager.add_status_effect(new_status)

func modify_floor() -> void:
	BattleService.s_battle_started.connect(on_battle_start)

func on_battle_start(battle: BattleManager) -> void:
	for cog in battle.cogs:
		hookup_cog(cog)
	battle.s_participant_joined.connect(func(participant): if participant is Cog: hookup_cog(participant))
	battle.s_status_effect_added.connect(on_status_effect_added)

func hookup_cog(cog: Cog) -> void:
	cog_hps[cog] = cog.stats.hp
	cog.stats.hp_changed.connect(cog_hp_changed.bind(cog))

func cog_hp_changed(hp: int, cog: Cog) -> void:
	if cog in cog_hps.keys() and is_instance_valid(BattleService.ongoing_battle) and cog.dna and cog.dna.is_crossover_cog:
		if cog_hps[cog] > hp and cog in BattleService.ongoing_battle.cogs:
			if BattleService.ongoing_battle.current_action is ToonAttack:
				apply_random_effect(cog)

func apply_random_effect(cog: Cog) -> void:
	var effect: StatusEffect = RANDOM_EFFECTS.pick_random().duplicate(true)
	effect.target = cog
	effect.randomize_effect()
	if effect is StatBoost:
		tweak_stat_boost(effect)
	if effect is StatEffectRegeneration:
		effect.instant_effect = false
	await Util.s_process_frame
	BattleService.ongoing_battle.add_status_effect(effect)

func tweak_stat_boost(effect: StatBoost) -> void:
	var valid_effects := ["defense", "damage", "accuracy"]
	if effect.stat not in valid_effects:
		effect.stat = valid_effects.pick_random()
	effect.quality = effect.EffectQuality.NEGATIVE
	effect.boost = randf_range(-0.10, -0.25)
	
func on_status_effect_added(effect: StatusEffect) -> void:
	if effect is StatusLured:
		apply_random_effect(effect.target)
