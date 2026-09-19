class_name ShieldAmountVariable extends DynamicVariable

const DEFAULT_NAME: String = &"ShieldAmount"

func update_value(card: CardModel) -> void:
	value = UpgradeHook.upgrade_shield_amount(card, _base_value)

func get_preview_value(card: CardModel, pile_type: Constants.PileType, _target: Creature) -> float:
	if should_run_global_hooks(pile_type):
		return Hook.modify_shield_amount_internal(card.combat_state, card.owner.creature, value, card)
	
	return value
