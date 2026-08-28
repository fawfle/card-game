class_name ModelDb extends StaticClass
## A class for storing/getting the base instance for models.
##
## Benefits are having everything stored in one central place so stuff like getting every character is easier. Generation is also automatic so every named class 
## extending [AbstractModel] is in ModelDb. [br][br]
## STS2 does some more complex stuff with its Ids for alleged speed, so keep that in mind. From my testing, using Scripts as dictionary keys was just as fast as other data
## types, so i'll definitely keep that for now.

static var _models_by_script: Dictionary[Script, AbstractModel] = {}

## Initialize the ModelDb. MUST be performed.
static func initialize() -> void:
	var start_time_usec: int = Time.get_ticks_usec()
	
	# It ain't pretty, but it probably works. Finds every class that inherits from AbstractModel, then initializes the base version of each.
	var class_list: Array[Dictionary] = ProjectSettings.get_global_class_list()
	
	var model_class_list: Array[Dictionary] = []
	var model_class_list_names: PackedStringArray = [&"AbstractModel"]
	var classes_added: int = 1 # 1 so the initial loop runs
	
	# Search through the entire class_list to find every class that inherits from AbstractModel. There's probably a more efficient way to do this, but even in a
	# worst case scenario, it should only run 3 times since there aren't any nested models.
	while classes_added > 0:
		classes_added = 0
		for class_dictionary: Dictionary in class_list:
			if not model_class_list_names.has(class_dictionary["class"]) and model_class_list_names.has(class_dictionary["base"]):
				model_class_list.push_back(class_dictionary)
				model_class_list_names.push_back(class_dictionary["class"])
				classes_added += 1
	
	
	model_class_list = model_class_list.filter(func(dictionary: Dictionary): return not dictionary["is_abstract"])
	
	for model_class_dictinary: Dictionary in model_class_list:
		var script: Script = load(model_class_dictinary["path"])
		_models_by_script[script] = script.new()
	
	print("ModelDb initialize() took %d usecs" % ((Time.get_ticks_usec() - start_time_usec)))

static func _get_model(type: Script) -> AbstractModel:
	return _models_by_script[type]

static func card(type: Script) -> CardModel:
	return _get_model(type)

static func character(type: Script) -> CharacterModel:
	return _get_model(type)

static func enemy(type: Script) -> EnemyModel:
	return _get_model(type)
