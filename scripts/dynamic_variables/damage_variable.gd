class_name DamageVariable extends DynamicVariable

const DEFAULT_NAME: String = &"Damage"

func update_value(card: CardModel) -> void:
	value = UpgradeHook.upgrade_damage(card, _base_value)

## Get the preview value. Uses pile_type to decide if it should be local or global.
func get_preview_value(card: CardModel, pile_type: Constants.PileType, target: Creature) -> float:
	if should_run_global_hooks(pile_type):
		return Hook.modify_damage(card.owner.run_state, card.combat_state, target, card.owner.creature, value, card)
	
	return value
