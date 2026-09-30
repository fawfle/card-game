class_name DebugConsoleCommandModel extends DebugConsoleCommand
## Open the upgrade menu with a specified upgrade

var model_base_classes: Dictionary[String, Script] = {}

func _init(name: String) -> void:
	super(name, _execute)
	
	for script: Script in ModelDb.model_base_classes:
		model_base_classes.set(script.get_global_name(), script)

func _execute(args: PackedStringArray) -> String:
	if len(args) < 2: return "need a base_class argument."
	var base_class_name: String = args[1]
	if not model_base_classes.has(base_class_name): return "could not find base class with name %s" % base_class_name
	var models: Array[AbstractModel] = ModelDb.get_all_models_by_base_script(model_base_classes.get(base_class_name))
	
	var result = ""
	
	for model: AbstractModel in models:
		result += model.get_id_name() + "\n"
	
	result += "found %d models." % [len(models)]
	
	return result;

func get_argument_completions(args: PackedStringArray) -> PackedStringArray:
	if args.size() == 2:
		return StringArrayHelper.get_all_with_prefix(model_base_classes.keys(), args[1])
	return []
