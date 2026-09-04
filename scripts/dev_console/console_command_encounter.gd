class_name ConsoleCommandEncounter extends DevConsoleCommand
## enter an arbitrary encounter

var encounter_names: PackedStringArray = []

func _init(name: String) -> void:
	super(name, _process)
	var encounter_model_scripts: Array[Script] =  [];
	encounter_model_scripts.assign(ModelDb.get_all_model_scripts_by_base_script(EncounterModel))
	
	for script: Script in encounter_model_scripts:
		encounter_names.push_back(script.get_global_name())

func _process(args: PackedStringArray) -> String:
	if len(args) < 2: return "need an encounter argument."
	var encounter_name: String = args[1]
	var encounter_model: EncounterModel = ModelDb.get_model_by_global_name(encounter_name)
	if not encounter_model: return "Could not find encounter with name %s." % encounter_name
	var combat_room: CombatRoom = CombatRoom.create_from_encounter(RunManager.instance.run_state, encounter_model.clone_mutable_from_base())
	RunManager.instance.enter_room(combat_room)
	return "Entered encounter %s successfully." % encounter_name

func get_argument_completions(args: PackedStringArray) -> PackedStringArray:
	if args.size() != 2: return []
	
	var res = []
	var current_name_arg: String = args[1]
	
	for encounter_name: String in encounter_names:
		if encounter_name.begins_with(current_name_arg):
			res.push_back(encounter_name)
	
	return res
