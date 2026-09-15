class_name DynamicVariableSet
## A set of dynamic variables

var list: Dictionary[String, DynamicVariable] = {}

## Returns the default damage var if it exists
var damage: DamageVariable:
	get(): return list[DamageVariable.DEFAULT_NAME]

var shield_amount: ShieldAmountVariable:
	get(): return list[ShieldAmountVariable.DEFAULT_NAME]

func _init(...dynamic_variables: Array) -> void:
	for variable: DynamicVariable in dynamic_variables:
		list.set(variable.name, variable)
