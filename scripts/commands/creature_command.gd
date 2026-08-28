class_name CreatureCommand extends StaticClass
## Commands for interacting with creatures.

## Does not need run_state or combat_state since those are derived from the target.
static func damage_creatures(targets: Array[Creature], dealer: Creature, damage: float, card_source: CardModel) -> void:
	for target: Creature in targets:
		damage_creature(target, dealer, damage, card_source)

static func damage_creature(target: Creature, dealer: Creature, damage: float, card_source: CardModel) -> void:
	var modified_damage: float = Hook.modify_damage(target.get_run_state(), target.combat_state, target, dealer, damage, card_source)
	var damage_after_shield: int = target.damage_shield_internal(int(modified_damage))
	target.lose_hp_internal(damage_after_shield)

## Adds a shield to a creature. If trying to create a shield, see [ShieldCommand].
static func add_shield(creature: Creature, shield: Shield, card_source: CardModel) -> void:
	var modified_shield: Shield = Hook.modify_shield(creature.combat_state, creature, shield, card_source)
	creature.add_shield_internal(modified_shield)

## Removes a shield from a creature.
static func remove_shield(creature: Creature, shield: Shield) -> void:
	creature.remove_shield_internal(shield)
