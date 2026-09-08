class_name DevConsole
## A debugging dev console.

## Maps command names to their commands
var _commands: Dictionary[String, DevConsoleCommand]

var history: PackedStringArray = []
var history_index: int = -1

func _init() -> void:
	_add_command(DevConsoleCommand.new("help", func(_args: PackedStringArray) -> String:
		return "\n".join(_commands.keys())))
	_add_command(DevConsoleCommand.new("test", func(args: PackedStringArray): return "test command args: " + " ".join(args)))
	_add_command(DevConsoleCommand.new("draw", func(args: PackedStringArray):
		if CombatManager.instance.is_over_or_completing: return "No combat is in progress."
		var count: int = 1 if len(args) == 1 else args[1].to_int()
		CardPileCommand.draw(RunManager.instance.run_state.player, count)
		return "drawing %d cards." % count))
	_add_command(DevConsoleCommand.new("damage", func(args: PackedStringArray):
		if CombatManager.instance.is_over_or_completing: return "No combat is in progress."
		var damage: int = args[1].to_int()
		CreatureCommand.damage_creatures(CombatManager.instance.combat_state.enemies, RunManager.instance.run_state.player.creature, damage, null)
		return "dealing %d damage." % damage
		))
	_add_command(DevConsoleCommand.new("kill", func(_args: PackedStringArray):
		if CombatManager.instance.is_over_or_completing: return "No combat is in progress."
		CreatureCommand.kill(CombatManager.instance.combat_state.enemies[0])
		return "Killing first creature."
		))
	_add_command(ConsoleCommandEncounter.new("encounter"))
	_add_command(ConsoleCommandCard.new("card"))

## Attempt to process a command, executing if valid.
func process_command(input: String) -> String:
	history.insert(0, input)
	history_index = -1
	
	var args: PackedStringArray = get_args(input)
	
	var command: DevConsoleCommand = _commands.get(args[0])
	
	if not command: 
		return "command '%s' not found" % args[0]
	
	return command.execute.call(args)

func get_completions(input: String) -> CompletionResults:
	var completion_results: CompletionResults = CompletionResults.new()
	
	var args: PackedStringArray = get_args(input)
	
	# handle completing command names
	if args.size() <= 1:
		for command_name: String in _commands.keys():
			if command_name.begins_with(input):
				completion_results.completions.append(command_name)
		
		return completion_results
	
	# handle completing command arguments
	var current_command: DevConsoleCommand = _commands.get(args[0])
	if current_command:
		completion_results.prefix = ""
		for i in range(len(args) - 1): completion_results.prefix += args[i] + " "
		completion_results.completions = current_command.get_argument_completions(args)
	
	return completion_results

## Separate for convenience reasons
func has_previous_command() -> bool:
	if history_index >= history.size() - 1:
		return false
	return true

func get_previous_command() -> String:
	history_index += 1
	return history[history_index]

func has_next_command() -> bool:
	if history_index <= -1:
		return false
	return true

func get_next_command() -> String:
	history_index -= 1
	if history_index <= -1: return ""
	return history[history_index]

func _add_command(command: DevConsoleCommand) -> void:
	_commands[command.command_name] = command

static func get_args(input) -> PackedStringArray:
	return input.split(" ")
