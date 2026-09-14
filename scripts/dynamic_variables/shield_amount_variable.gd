class_name ShieldAmountVariable extends DynamicVariable

const DEFAULT_NAME: String = &"ShieldAmount"

func get_preview_value(card: CardModel, pile_type: Constants.PileType, _target: Creature) -> float:
	var run_global_hooks: bool = pile_type == Constants.PileType.HAND or pile_type == Constants.PileType.HAND
	if run_global_hooks:
		preview_value = Hook.modify_shield_amount_internal(card.combat_state, card.owner.creature, base_value, card)
		return preview_value
	
	preview_value = Hook.upgrade_shield_amount_internal(card, base_value)
	return preview_value
