class_name CompletionResults
## Data storing information for autocompletions for a DevConsole.

## The prefix to be included before the completion candidates. i.e. the command name.
var prefix: String = ""

## The completion candidates
var completions: PackedStringArray

var has_unique_completion: bool:
	get(): return completions.size() == 1

func get_best_completion() -> String:
	if has_unique_completion: return get_unique_completion()
	return prefix + get_longest_common_prefix()

## If there is only 1 valid completion, return it. Otherwise returns and empty string.
func get_unique_completion() -> String:
	if completions.size() != 1: return ""
	
	return prefix + completions[0]

func get_longest_common_prefix() -> String:
	if completions.size() <= 0: return ""
	
	var candidate_word: String = completions[0]
	var common_substring: String = ""
	for i in len(candidate_word):
		for j in range(1, len(completions)):
			if len(completions[j]) <= i: return common_substring
			if candidate_word[i] != completions[j][i]: return common_substring
		common_substring += candidate_word[i]
	return common_substring
