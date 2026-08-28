class_name DevConsole
## A debugging dev console.

## Maps command names to their commands
var _commands: Dictionary[String, DevConsoleCommand]

var _history: PackedStringArray = []
var history_index: int = 0

func _init() -> void:
	_add_command(DevConsoleCommand.new("test", func(args: PackedStringArray): return "test command args: " + " ".join(args)))
	_add_command(DevConsoleCommand.new("draw", func(args: PackedStringArray):
		var count: int = 1 if len(args) == 1 else args[1].to_int()
		CardPileCommand.draw(RunManager.instance.run_state.player, count)
		return "drawing %d cards." % count))

## Attempt to process a command, executing if valid.
func process_command(input: String) -> String:
	_history.insert(0, input)
	
	var args: PackedStringArray = input.split(" ")
	
	var command: DevConsoleCommand = _commands.get(args[0])
	
	if not command: 
		return "command '%s' not found" % args[0]
	
	return command.process.call(args)

func _add_command(command: DevConsoleCommand) -> void:
	_commands[command.command_name] = command
