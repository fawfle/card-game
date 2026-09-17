class_name DamageVariable extends DynamicVariable

const DEFAULT_NAME: String = &"Damage"

## Get the preview value. Uses pile_type to decide if it should be local or global.
func get_preview_value(card: CardModel, pile_type: Constants.PileType, target: Creature) -> float:
	if should_run_global_hooks(pile_type):
		preview_value = Hook.modify_damage(card.owner.run_state, card.combat_state, target, card.owner.creature, base_value, card)
		return preview_value
	
	return get_preview_value_local(card)

## Explicity get the local preview value (upgraded but not changed by effects etc.)
func get_preview_value_local(card: CardModel) -> float:
	preview_value = Hook.upgrade_damage_internal(card, base_value)
	return preview_value
