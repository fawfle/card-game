class_name DurationVariable extends DynamicVariable

const DEFAULT_NAME: String = &"Duration"

func _init(variable_base_value: float) -> void:
	super(DEFAULT_NAME, variable_base_value)

func update_value(card: CardModel) -> void:
	value = UpgradeHook.upgrade_card_duration(card, _base_value)

## Get the preview value. Uses pile_type to decide if it should be local or global.
func get_preview_value(card: CardModel, pile_type: Constants.PileType, _target: Creature) -> float:
	if should_run_global_hooks(pile_type):
		return Hook.modify_card_duration(card.combat_state, card, value)
	
	return value

## Call [method update_value] after duplicating.
func duplicate_deep() -> DynamicVariable: return DurationVariable.new(_base_value)
