class_name DevConsole
## A debugging dev console.

## Maps command names to their commands
var _commands: Dictionary[String, DevConsoleCommand]

var history: PackedStringArray = []
var history_index: int = -1

func _init() -> void:
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

## Attempt to process a command, executing if valid.
func process_command(input: String) -> String:
	history.insert(0, input)
	history_index = -1
	
	var args: PackedStringArray = input.split(" ")
	
	var command: DevConsoleCommand = _commands.get(args[0])
	
	if not command: 
		return "command '%s' not found" % args[0]
	
	return command.process.call(args)

func get_completions(input: String) -> PackedStringArray:
	var completions: PackedStringArray = []
	
	for command_name: String in _commands.keys():
		if command_name.begins_with(input):
			completions.append(command_name)
	
	return completions

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
