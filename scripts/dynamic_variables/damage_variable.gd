class_name DamageVariable extends DynamicVariable

const DEFAULT_NAME: String = &"Damage"

func get_preview_value(card: CardModel, pile_type: Constants.PileType, target: Creature) -> float:
	var run_global_hooks: bool = pile_type == Constants.PileType.HAND or pile_type == Constants.PileType.HAND
	if run_global_hooks:
		preview_value = Hook.modify_damage(card.owner.run_state, card.combat_state, target, card.owner.creature, base_value, card)
		return preview_value
	
	preview_value = Hook.upgrade_damage_internal(card, base_value)
	return preview_value
