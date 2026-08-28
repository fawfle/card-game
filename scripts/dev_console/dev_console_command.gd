class_name DevConsoleCommand

var command_name: String = ""
var process: Callable = Callable()

func _init(name: String, process_callable: Callable) -> void:
	command_name = name
	process = process_callable
