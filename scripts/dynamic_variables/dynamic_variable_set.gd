class_name DynamicVariableSet
## A set of dynamic variables

var list: Dictionary[String, DynamicVariable] = {}

## Returns the default damage var if it exists
var damage: DamageVariable:
	get(): return list[DamageVariable.DEFAULT_NAME]

var shield_amount: ShieldAmountVariable:
	get(): return list[ShieldAmountVariable.DEFAULT_NAME]

func _init(dynamic_variables: Array[DynamicVariable]) -> void:
	for variable: DynamicVariable in dynamic_variables:
		list.set(variable.name, variable)

func update_values(card: CardModel) -> void:
	for variable: DynamicVariable in list.values():
		variable.update_value(card)

## Duplicate self. Call [method update_values] after.
func duplicate_deep() -> DynamicVariableSet:
	var variables: Array[DynamicVariable] = []
	variables.assign(list.values().map(func(variable: DynamicVariable): return variable.duplicate_deep()))
	return DynamicVariableSet.new(variables)
