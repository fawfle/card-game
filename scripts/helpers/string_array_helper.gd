class_name StringArrayHelper extends StaticClass
## perform common tasks with string arrays (PackedStringArrays)

static func get_all_with_prefix(array: PackedStringArray, prefix: String) -> PackedStringArray:
	var res: PackedStringArray = []
	for string: String in array:
		if string.begins_with(prefix):
			res.push_back(string)
	return res
