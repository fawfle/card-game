class_name CreatureCommand extends StaticClass
## Commands for interacting with creatures.

## Does not need run_state or combat_state since those are derived from the target.
static func damage_creatures(targets: Array[Creature], dealer: Creature, damage: float, card_source: CardModel) -> void:
	for target: Creature in targets:
		damage_creature(target, dealer, damage, card_source)

static func damage_creature(target: Creature, dealer: Creature, damage: float, card_source: CardModel) -> void:
	var run_state: RunState = RunManager.instance.run_state
	var combat_state: CombatState = target.combat_state
	var modified_damage: float = Hook.modify_damage(target.get_run_state(), target.combat_state, target, dealer, damage, card_source)
	# TODO: Hook.before_damage_dealt(run_state, combat_state, target, modified_damage, dealer, card_source)
	var damage_after_shield: int = target.damage_shield_internal(int(modified_damage), dealer)
	target.lose_hp_internal(damage_after_shield)
	# TODO: add hook for after_damage_dealt with information about the attack.
	
	if target.is_dead:
		kill(target)

## Kills a creature and then checks if combat should be ended.
static func kill(creature: Creature) -> void:
	kill_internal(creature)
	
	if creature.player:
		CombatManager.instance.lose_combat()
	
	CombatManager.instance.check_if_combat_ended()

## Organizational. Handles the logic of killing a creature. Don't use directly, instead use [method kill]. A bit of plagiarism.
static func kill_internal(creature: Creature) -> void:
	if creature.current_hp > 0:
		creature.lose_hp_internal(creature.current_hp)
	
	var creature_node: CreatureNode = creature.get_creature_node()
	if creature_node: CombatRoomNode.instance.remove_creature_node(creature_node)
	
	CombatManager.instance.combat_state.remove_creature(creature)

## Adds a shield to a creature. If trying to create a shield, see [ShieldCommand].
static func add_shield(creature: Creature, shield: Shield, card_source: CardModel) -> void:
	var modified_shield: Shield = Hook.modify_shield(creature.combat_state, creature, shield, card_source)
	creature.add_shield_internal(modified_shield)

## Removes a shield from a creature.
static func remove_shield(creature: Creature, shield: Shield) -> void:
	creature.remove_shield_internal(shield)

## For [param effect_base]. Create the effect using [EffectCommand]. Avoid using directly, see [method EffectCommand.execute].
static func apply_effect(target: Creature, effect_model: EffectModel, applier: Creature, card_source: CardModel) -> void:
	var effect: EffectModel = find_existing_effect_for_stacking(target, effect_model)
	if effect != null:
		effect.amount += effect_model.amount
		# find_existing_effect_for_stacking ensures that both effect and effect_model have same temporary type.
		if effect.is_temporary:
			effect.time_left += effect_model.duration
			effect.duration += effect_model.duration
		return
	
	if effect == null: effect = effect_model
	effect.applier = applier
	effect.card_source = card_source
	effect.apply_internal(target)

## see if a creature has a power, mostly to modify it instead of adding a copy. Searches for a temporary effect if [param effect] is temporary.
static func find_existing_effect_for_stacking(target: Creature, effect: EffectModel) -> EffectModel:
	return target.get_effect_instance(effect)

static func play_animation(creature: Creature, animation: String) -> void:
	var creature_node: CreatureNode = creature.get_creature_node()
	if not creature_node: return
	creature_node.animation_player.stop()
	creature_node.animation_player.play(animation)
