class_name CompletionResults
## Data storing information for autocompletions for a DevConsole.

## The prefix to be included before the completion candidates. i.e. the command name.
var prefix: String = ""

## The completion candidates
var completions: PackedStringArray

## If there is only 1 valid completion, return it. Otherwise returns and empty string.
func get_only_completion() -> String:
	if completions.size() != 1: return ""
	
	return prefix + completions[0]
