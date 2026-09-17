class_name CardKeywordHelper
## A static class for managing card keywords.
##
## For actual keyword values, see [enum Constants.CardKeyword].

static func get_title(keyword: Constants.CardKeyword) -> String:
	match(keyword):
		Constants.CardKeyword.FRAGILE: return "Fragile"
	return "Broken Keyword Title"

static func get_description(keyword: Constants.CardKeyword) -> String:
	match(keyword):
		Constants.CardKeyword.FRAGILE: return "Cancelled upon taking any damage."
	return "Broken Keyword Description"
