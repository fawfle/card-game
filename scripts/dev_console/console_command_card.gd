class_name ConsoleCommandCard extends DevConsoleCommand
## draw an arbitrary card

var card_names: PackedStringArray = []

func _init(name: String) -> void:
	super(name, _execute)
	var model_scripts: Array[Script] =  [];
	model_scripts.assign(ModelDb.get_all_model_scripts_by_base_script(CardModel))
	
	for script: Script in model_scripts:
		card_names.push_back(script.get_global_name())

func _execute(args: PackedStringArray) -> String:
	if len(args) < 2: return "needs a card argument."
	var card_name: String = args[1]
	var card_model: CardModel = ModelDb.get_model_by_global_name(card_name)
	if not card_model: return "Could not find card with name %s." % card_name
	
	var pile_type: Constants.PileType = Constants.PileType.HAND
	if len(args) >= 3:
		var args_pile_name: String = args[2]
		if Constants.PileType.has(args_pile_name):
			pile_type = Constants.PileType.get(args_pile_name)
		else:
			return "Could not find PileType with name %s" % args_pile_name
	
	if pile_type != Constants.PileType.DECK and not CombatManager.instance.is_in_progress: return "Combat is not in progress."
	
	var card: CardModel = card_model.clone_mutable_from_base()
	RunManager.instance.run_state.player.register_card(card)
	CardPileCommand.add_to_pile(RunManager.instance.run_state.player.get_pile(pile_type), card)
	return "Added card %s to %s successfully." % [card_name, Constants.PileType.keys()[pile_type]]

func get_argument_completions(args: PackedStringArray) -> PackedStringArray:
	if args.size() == 2:
		return StringArrayHelper.get_all_with_prefix(card_names, args[1])
	if args.size() == 3:
		return StringArrayHelper.get_all_with_prefix(Constants.PileType.keys(), args[2])
	return []
