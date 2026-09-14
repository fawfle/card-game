class_name DynamicVariableSet
## A set of dynamic variables

var variables: Dictionary[String, DynamicVariable] = {}

## Returns the default damage var if it exists
var damage: DamageVariable:
	get(): return variables[DamageVariable.DEFAULT_NAME]

var shield_amount: ShieldAmountVariable:
	get(): return variables[ShieldAmountVariable.DEFAULT_NAME]

func _init(...dynamic_variables: Array) -> void:
	for variable: DynamicVariable in dynamic_variables:
		variables.set(variable.name, variable)
