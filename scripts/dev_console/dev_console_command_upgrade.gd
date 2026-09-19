class_name DevConsoleCommandUpgrade extends DevConsoleCommand
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
	var selected_card: CardModel = await CardSelectCommand.select_card_for_upgrade(RunManager.instance.run_state.player, upgrade_model)
	var upgrade: UpgradeModel = upgrade_model.clone_mutable_from_base()
	if upgrade.has_method("set_amounts"):
		var argc: int = upgrade.get_method_argument_count("set_amounts")
		# I'm lazy and upgrades probably won't have a ton of values to set, so hardcoding in a debugging setting is for now is fine.
		var amount_one: int = int(args[2]) if len(args) >= 3 else 1
		var amount_two: int = int(args[3]) if len(args) >= 4 else 1
		if argc == 1:
			upgrade.set_amounts(amount_one)
		if argc == 2:
			upgrade.set_amounts(amount_one, amount_two)
		
	CardCommand.upgrade(selected_card, upgrade)
	return "Upgraded card %s with upgrade %s." % [selected_card.get_id_name(), upgrade_name]

func get_argument_completions(args: PackedStringArray) -> PackedStringArray:
	if args.size() == 2:
		return StringArrayHelper.get_all_with_prefix(upgrade_names, args[1])
	return []
