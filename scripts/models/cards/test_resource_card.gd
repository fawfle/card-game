class_name TestResourceCard extends CardModel

func get_target_type() -> Constants.TargetType: return Constants.TargetType.ENEMY

func get_pathos_cost() -> int: return 1
# func get_logos_cost() -> int: return 1

func get_description() -> String: return "Costs %d pathos." % get_pathos_cost_with_modifiers()
