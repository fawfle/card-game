class_name DynamicVariable
## A special variable that handles displaying game state related info.
##
## Dynamic Variables primarily handle DISPLAY info. When using for calcuations, only use [member base_value].

var base_value: float

## The value to be shown
var preview_value: float

var base_value_int: int:
	get(): return int(base_value)
	set(value): base_value = value 

var name: String

func _init(variable_name: String, variable_base_value: float) -> void:
	name = variable_name
	base_value = variable_base_value

func get_preview_value(_card: CardModel, _pile_type: Constants.PileType, _target: Creature) -> float:
	return base_value
