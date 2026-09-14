class_name ConsoleCommandUpgrade extends DevConsoleCommand
## Open the upgrade menu with a specified upgrade

var upgrade_names: PackedStringArray = []

func _init(name: String) -> void:
	super(name, _execute)
	var upgrade_model_scripts: Array[Script] =  [];
	upgrade_model_scripts.assign(ModelDb.get_all_model_scripts_by_base_script(UpgradeModel))
	
	for script: Script in upgrade_model_scripts:
		upgrade_names.push_back(script.get_global_name())

func _execute(args: PackedStringArray) -> String:
	if not RunManager.instance: return "No run in progress."
	if len(args) < 2: return "need an upgrade argument."
	var upgrade_name: String = args[1]
	var upgrade_model: UpgradeModel = ModelDb.get_model_by_global_name(upgrade_name)
	if not upgrade_model: return "Could not find upgrade with name %s." % upgrade_name
	var selected_card: CardModel = await CardSelectCommand.select_card_for_upgrade(RunManager.instance.run_state.player)
	CardCommand.upgrade(selected_card, upgrade_model.clone_mutable())
	return "Upgraded card %s with upgrade %s." % [selected_card.get_id_name(), upgrade_name]

func get_argument_completions(args: PackedStringArray) -> PackedStringArray:
	if args.size() == 2:
		return StringArrayHelper.get_all_with_prefix(upgrade_names, args[1])
	return []
