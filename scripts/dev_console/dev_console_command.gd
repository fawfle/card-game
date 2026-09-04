class_name DevConsoleCommand

var command_name: String = ""
var process: Callable = Callable()

## process_callable is expected to take in args: PackedStringArray and return String.
func _init(name: String, process_callable: Callable) -> void:
	command_name = name
	process = process_callable

func get_argument_completions(_args: PackedStringArray) -> PackedStringArray:
	return []
