class_name ShieldAmountVariable extends DynamicVariable

const DEFAULT_NAME: String = &"ShieldAmount"

func get_preview_value(card: CardModel, pile_type: Constants.PileType, _target: Creature) -> float:
	if should_run_global_hooks(pile_type):
		preview_value = Hook.modify_shield_amount_internal(card.combat_state, card.owner.creature, base_value, card)
		return preview_value
	
	return get_preview_value_local(card)

func get_preview_value_local(card: CardModel) -> float:
	preview_value = Hook.upgrade_shield_amount_internal(card, base_value)
	return preview_value
