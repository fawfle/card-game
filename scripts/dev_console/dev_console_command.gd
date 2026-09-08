class_name DevConsoleCommand

var command_name: String = ""
var execute: Callable = Callable()

## execute_callable is expected to take in args: PackedStringArray and return String.
func _init(name: String, execute_callable: Callable) -> void:
	command_name = name
	execute = execute_callable

func get_argument_completions(_args: PackedStringArray) -> PackedStringArray:
	return []
