@abstract
class_name DynamicVariable
## A special variable that handles displaying game state related info.
##
## Dynamic Variables handle both display and upgrades. For calculations, see [member value]. [br]
## NOTE: I'm not sure if having tied variables that need to be duplicated is "better" that a single shared base variable.
## It shouldn't matter, but theoretically has a larger overhead since you need to duplicate variables a lot.

## The base value, used as a base when calculating the actual value. Do not modify unless you have a good reason.
var _base_value: float

## The actual value to be used in calculations. Has upgrades applied, but not hooks.
var value: float

var name: String

func _init(variable_name: String, variable_base_value: float) -> void:
	name = variable_name
	_base_value = variable_base_value
	value = _base_value

## Recalculate the intrinsic value. This should be called any time the dynamic variable should be changed, like after adding an upgrade.
## This does NOT need to be called when using normal hooks. Make sure to actually set value within this function.
func update_value(_card: CardModel) -> void:
	pass

## The value to be shown (DO NOT USE FOR CALCULATIONS). If applicable, will be the value after hooks are applied.
func get_preview_value(_card: CardModel, _pile_type: Constants.PileType, _target: Creature) -> float:
	return value

func should_run_global_hooks(pile_type: Constants.PileType) -> bool:
	return pile_type == Constants.PileType.HAND or pile_type == Constants.PileType.HAND

func duplicate_deep() -> DynamicVariable:
	return (get_script() as Script).new(name, _base_value)
